import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zo_app_blocker/zo_app_blocker.dart';
import '../../models/task_model.dart';
import '../../core/app_colors.dart';
import '../providers/task_provider.dart';
import '../services/sound_service.dart';
import '../widgets/focus_sound_selector.dart';
import '../services/focus_sounds.dart';
import '../services/notification_service.dart';
import '../services/focus_notification_service.dart';
import '../services/focus_foreground_service.dart';
import '../services/notification_service.dart';

enum FocusState { idle, working, paused, breaking }

class FocusScreen extends StatefulWidget {
  final TaskModel task;
  const FocusScreen({super.key, required this.task});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  FocusState _currentState = FocusState.idle;
  late int _totalSeconds;
  late int _secondsLeft;
  Timer? _timer;
  DateTime? _endTime;
  String? selectedSoundId;
  final SoundService _soundService = SoundService();

  final List<String> _appsToLockdown = [
    'com.instagram.android',
    'com.facebook.katana',
    'com.zhiliaoapp.musically',
  ];

  @override
  void initState() {
    super.initState();
    selectedSoundId = widget.task.focusSoundId;

    _resetSessionState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _soundService.stopSound();
    ZoAppBlocker.instance.unblockAll();
    super.dispose();
  }

  void _resetSessionState() {
    _timer?.cancel();
    _timer = null;

    int minutes = widget.task.durationMinutes > 0
        ? widget.task.durationMinutes
        : 45;

    setState(() {
      _totalSeconds = minutes * 60;
      _secondsLeft = _totalSeconds;
      _currentState = FocusState.idle;
    });
  }

  //  Sequentially verify all native hardware/OS permissions
  Future<bool> _ensureAndroidPermissionsReady() async {
    // 1. Notification Rights (Android 13+)
    final notifyStatus = await ZoAppBlocker.instance
        .checkNotificationPermission();
    if (notifyStatus != 'granted') {
      await ZoAppBlocker.instance.requestNotificationPermission();
      return false;
    }

    // 2. Usage Stats Access
    final usageStatus = await ZoAppBlocker.instance.checkUsageStatsPermission();
    if (usageStatus == 'denied') {
      await ZoAppBlocker.instance.requestUsageStatsPermission();
      return false;
    }

    // 3. System Alert Overlay Canvas Draw Authorization
    final overlayStatus = await ZoAppBlocker.instance.checkOverlayPermission();
    if (overlayStatus == 'denied') {
      await ZoAppBlocker.instance.requestOverlayPermission();
      return false;
    }

    return true;
  }

  void _startFocusSession() async {
    // 1. Verify all three native permissions are fully active
    final permissionsGranted = await _ensureAndroidPermissionsReady();
    if (!permissionsGranted) {
      // Safety halt: The native OS has open settings views on top of our app.
      return;
    }

    setState(() {
      _currentState = FocusState.working;
    });

    await FocusForegroundService.start(_secondsLeft);

    // شغل الصوت بعد تشغيل الـ Foreground Service
    if (selectedSoundId != null) {
      final sound = focusSounds.firstWhere((s) => s.id == selectedSoundId);
      if (selectedSoundId != null) {
        final sound = focusSounds.firstWhere((s) => s.id == selectedSoundId);

        print("STARTING SOUND: ${sound.assetPath}");

        await _soundService.startSound(sound.assetPath);

        print("SOUND STARTED");
      }
    }

    await NotificationService.showNotification(
      id: 1000,
      title: "Focus Started",
      body: "Your focus session has begun. Stay focused!",
    );

    // 4. Safely initialize native foreground service and application restriction hooks
    try {
      await ZoAppBlocker.instance.setNotificationConfig(
        notificationBannerTitle: 'Focus Mode Active',
        notificationBannerDescription:
            'Monitoring applications for: ${widget.task.title.isEmpty ? "Deep Work" : widget.task.title}',
      );

      // Engage the headless device lock restrictions
      await ZoAppBlocker.instance.blockApps(_appsToLockdown);
    } catch (e) {
      debugPrint("Native App Blocker Service failed to initialize: $e");
      // Handle gracefully (e.g., show a quick snackbar to the user)
    }

    // 5. Kick off the synchronized time ticker
    _startCountdownTicker();
  }

  void _startCountdownTicker() {
    _timer?.cancel();
    _endTime = DateTime.now().add(Duration(seconds: _secondsLeft));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final remaining = _endTime!.difference(DateTime.now()).inSeconds;

      if (remaining > 0) {
        setState(() {
          _secondsLeft = remaining;
        });
        await FocusNotificationService.showRunningNotification(
          secondsLeft: _secondsLeft,
          paused: false,
        );
      } else {
        _timer?.cancel();
        _handleTimerCompletion();
      }
    });
  }

  void _togglePauseResume() async {
    if (_currentState == FocusState.working) {
      await _soundService.pauseSound();
      _timer?.cancel();

      // Lift blocking mechanisms during temporary pause intervals
      await ZoAppBlocker.instance.unblockAll();

      setState(() {
        _currentState = FocusState.paused;
      });
      await FocusNotificationService.showRunningNotification(
        secondsLeft: _secondsLeft,
        paused: true,
      );
    } else if (_currentState == FocusState.paused) {
      await _soundService.resumeSound();
      // Re-engage native engine blocks
      await ZoAppBlocker.instance.blockApps(_appsToLockdown);

      setState(() {
        _currentState = FocusState.working;
      });
      await FocusNotificationService.showRunningNotification(
        secondsLeft: _secondsLeft,
        paused: false,
      );
      _startCountdownTicker();
    }
  }

  void _handleTimerCompletion() async {
    await _soundService.stopSound();
    await _soundService.playCompletionSound();
    await NotificationService.showTimerFinishedNotification();
    await FocusForegroundService.stop();
    await FocusNotificationService.stopNotification();
    // Lift native blocks completely before transitioning views
    await ZoAppBlocker.instance.unblockAll();
    await NotificationService.showNotification(
      id: 1001,
      title: "Focus Session Complete!",
      body: "Great job! Time for a short break.",
    );

    if (_currentState == FocusState.working) {
      int minutesEarned = _totalSeconds ~/ 60;
      if (!mounted) return;

      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      if (widget.task.id != "default") {
        final updatedTask = widget.task.copyWith(
          actualTimeSpentMinutes:
              widget.task.actualTimeSpentMinutes + minutesEarned,
          focusSessions: widget.task.focusSessions + 1,
        );

        await taskProvider.updateTask(updatedTask);
      }

      setState(() {
        _currentState = FocusState.breaking;
        _totalSeconds = 5 * 60;
        _secondsLeft = _totalSeconds;
      });
      _startCountdownTicker();
      _showAlert(
        "Session Finished!",
        "Great job! Time spent data has been securely recorded. Enjoy a 5-minute break.",
      );
    } else if (_currentState == FocusState.breaking) {
      _resetSessionState();
      _showAlert("Break Over!", "Ready to lock back in for another session?");
    }
  }

  void _quitSessionConfirm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Abandon Focus Session?"),
        content: const Text(
          "This will stop your timer progress and lift your current application blocks.",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _soundService.stopCompletionSound();

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text("OK"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.pop(context);
              _timer?.cancel();
              await _soundService.stopSound();
              await _soundService.stopCompletionSound();
              await FocusForegroundService.stop();
              await FocusNotificationService.stopNotification();

              // Lift constraints cleanly on structural drop metrics
              await ZoAppBlocker.instance.unblockAll();

              int elapsedSeconds = _totalSeconds - _secondsLeft;
              int minutesEarned = elapsedSeconds ~/ 60;

              if (minutesEarned > 0) {
                if (!context.mounted) return;
                final taskProvider = Provider.of<TaskProvider>(
                  context,
                  listen: false,
                );
                if (widget.task.id != "default") {
                  final updatedTask = widget.task.copyWith(
                    actualTimeSpentMinutes:
                        widget.task.actualTimeSpentMinutes + minutesEarned,
                  );
                  final navigator = Navigator.of(context);
                  await taskProvider.updateTask(updatedTask);
                  navigator.pop();
                }
              }
              await FocusForegroundService.stop();
              await FocusNotificationService.stopNotification();

              _timer?.cancel();
              _timer = null;

              setState(() {
                _currentState = FocusState.idle;
                _secondsLeft = _totalSeconds;
              });
            },
            child: const Text("Quit", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAlert(String title, String body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () async {
              await _soundService.stopCompletionSound();

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    double progress = _totalSeconds > 0 ? _secondsLeft / _totalSeconds : 0.0;
    String statusLabel = _currentState == FocusState.working
        ? "DEEP WORK"
        : (_currentState == FocusState.breaking ? "REST BREAK" : "READY");
    Color ringColor = _currentState == FocusState.breaking
        ? Colors.green
        : AppColors.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  widget.task.title.isEmpty
                      ? "General Focus Session"
                      : widget.task.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 190,
                      height: 190,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(ringColor),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(_secondsLeft),
                          style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          statusLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                if (_currentState == FocusState.idle)
                  Column(
                    children: [
                      const Text(
                        "🎧 Focus Sound",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 12),

                      FocusSoundSelector(
                        selectedSoundId: selectedSoundId,
                        onSelected: (value) {
                          setState(() {
                            selectedSoundId = value;
                          });
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                if (_currentState != FocusState.idle) SizedBox(height: 40),
                Column(
                  children: [
                    if (_currentState == FocusState.idle)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: _startFocusSession,
                          child: const Text(
                            "Start Focus Now",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    if (_currentState == FocusState.working ||
                        _currentState == FocusState.paused) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: _togglePauseResume,
                          child: Text(
                            _currentState == FocusState.paused
                                ? "Resume Work"
                                : "Pause Focus",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (_currentState != FocusState.idle)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.redAccent),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: _quitSessionConfirm,
                          child: const Text(
                            "Quit Session",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
