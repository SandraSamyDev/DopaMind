import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zo_app_blocker/zo_app_blocker.dart';
import '../../models/task_model.dart';
import '../../core/app_colors.dart';
import '../providers/task_provider.dart';

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

  // 🧠 Hardcoded test target apps (can be dynamically populated from HomeScreen later)
  final List<String> _appsToLockdown = [
    'com.instagram.android',
    'com.facebook.katana',
    'com.zhiliaoapp.musically', // TikTok
  ];

  @override
  void initState() {
    super.initState();
    _resetSessionState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resetSessionState() {
    _timer?.cancel();
    int minutes = (widget.task.durationMinutes > 0) ? widget.task.durationMinutes : 25;
    setState(() {
      _totalSeconds = minutes * 60;
      _secondsLeft = _totalSeconds;
      _currentState = FocusState.idle;
    });
  }

  // 🧠 Sequentially verify all native hardware/OS permissions
  Future<bool> _ensureAndroidPermissionsReady() async {
    // 1. Notification Rights (Android 13+)
    final notifyStatus = await ZoAppBlocker.instance.checkNotificationPermission();
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
    final permissionsGranted = await _ensureAndroidPermissionsReady();
    if (!permissionsGranted) {
      // Safety halt: The native OS has open settings views on top of the app.
      return; 
    }

    // Configure persistent foreground service notification banner asset
    await ZoAppBlocker.instance.setNotificationConfig(
      notificationBannerTitle: 'Focus Mode Active',
      notificationBannerDescription: 'Monitoring applications for: ${widget.task.title.isEmpty ? "Deep Work" : widget.task.title}',
    );

    // Engage the headless device lock restrictions
    await ZoAppBlocker.instance.blockApps(_appsToLockdown);

    setState(() {
      _currentState = FocusState.working;
    });

    _startCountdownTicker();
  }

  void _startCountdownTicker() {
    _timer?.cancel();
    _endTime = DateTime.now().add(Duration(seconds: _secondsLeft));

    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      final remaining = _endTime!.difference(DateTime.now()).inSeconds;

      if (remaining > 0) {
        setState(() {
          _secondsLeft = remaining;
        });
      } else {
        _timer?.cancel();
        _handleTimerCompletion();
      }
    });
  }

  void _togglePauseResume() async {
    if (_currentState == FocusState.working) {
      _timer?.cancel();
      
      // Lift blocking mechanisms during temporary pause intervals
      await ZoAppBlocker.instance.unblockAll();
      
      setState(() {
        _currentState = FocusState.paused;
      });
    } else if (_currentState == FocusState.paused) {
      // Re-engage native engine blocks
      await ZoAppBlocker.instance.blockApps(_appsToLockdown);
      
      setState(() {
        _currentState = FocusState.working;
      });
      _startCountdownTicker();
    }
  }

  void _handleTimerCompletion() async {
    // Lift native blocks completely before transitioning views
    await ZoAppBlocker.instance.unblockAll();

    if (_currentState == FocusState.working) {
      int minutesEarned = _totalSeconds ~/ 60;
      if (!mounted) return;
      
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final updatedTask = widget.task.copyWith(
        actualTimeSpentMinutes: widget.task.actualTimeSpentMinutes + minutesEarned,
        isCompleted: true,
        completedAt: DateTime.now(),
      );
      taskProvider.updateTask(updatedTask);
      
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
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.pop(context);
              _timer?.cancel();
              
              // Lift constraints cleanly on structural drop metrics
              await ZoAppBlocker.instance.unblockAll();
              
              int elapsedSeconds = _totalSeconds - _secondsLeft;
              int minutesEarned = elapsedSeconds ~/ 60;

              if (minutesEarned > 0) {
                final taskProvider = Provider.of<TaskProvider>(context, listen: false);
                final updatedTask = widget.task.copyWith(
                  actualTimeSpentMinutes: widget.task.actualTimeSpentMinutes + minutesEarned,
                );
                taskProvider.updateTask(updatedTask);
              }
              _resetSessionState();
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
            onPressed: () => Navigator.pop(context),
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
    Color ringColor = _currentState == FocusState.breaking ? Colors.green : AppColors.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.task.title.isEmpty ? "General Focus Session" : widget.task.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    height: 220,
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
                        style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        statusLabel,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600, letterSpacing: 1.5),
                      ),
                    ],
                  ),
                ],
              ),
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
                  if (_currentState == FocusState.working || _currentState == FocusState.paused) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _togglePauseResume,
                        child: Text(
                          _currentState == FocusState.paused ? "Resume Work" : "Pause Focus",
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
    );
  }
}