import 'dart:async';
import 'package:dopamind/services/block_service.dart';
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'package:dopamind/services/notification_service.dart';
import 'package:audioplayers/audioplayers.dart';

class PanicFocusScreen extends StatefulWidget {
  final String taskTitle;
  final int totalMinutes;

  const PanicFocusScreen({
    super.key,
    required this.taskTitle,
    required this.totalMinutes,
  });

  @override
  State<PanicFocusScreen> createState() => _PanicFocusScreenState();
}

class _PanicFocusScreenState extends State<PanicFocusScreen> {
  final BlockerService _blockerService = BlockerService() ;// Singleton reference
  late int remainingSeconds;
  Timer? timer;
  final AudioPlayer _player = AudioPlayer();
  bool _isServiceInitialized = false;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.totalMinutes * 60;

    NotificationService.showPanicNotification(
      taskTitle: widget.taskTitle,
      remaining: Duration(seconds: remainingSeconds),
    );

    startTimer();
    _startEmergencySession();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });

        NotificationService.showPanicNotification(
          taskTitle: widget.taskTitle,
          remaining: Duration(seconds: remainingSeconds),
        );
      } else {
        timer.cancel();
        await _handleSessionCompletion();
      }
    });
  }

  // Orchestrates native configuration, permissions, and app blocking sequence
  Future<void> _startEmergencySession() async {
    try {
      // 1. Initialize SharedPreferences data layer
      await _blockerService.init();
      setState(() {
        _isServiceInitialized = true;
      });

      // 2. Set up the custom foreground banner text
      await _blockerService.configureBackgroundNotification();

      // 3. Trigger permission handlers
      await _blockerService.handleNotificationPermission();
      await _blockerService.handleUsageStatsandOverlay();

      // 4. Force override or seed emergency apps if your blacklist is currently empty
      if (_blockerService.blockedAppsCount == 0) {
        await _blockerService.updateSelectedPackages([
          'com.instagram.android',
          'com.facebook.katana',
          'com.zhiliaoapp.musically',
        ]);
      }

      // 5. Fire up native background blockers
      await _blockerService.startLockdown();
      debugPrint("Native emergency lockdown successfully started.");
    } catch (e) {
      debugPrint("Failed to establish emergency lockdown pipelines: $e");
    }
  }

  // Handles logic when the timer runs down organically
  Future<void> _handleSessionCompletion() async {
    await NotificationService.cancelPanicNotification();
    await _blockerService.stopLockdown(); // Lift application blocks cleanly
    
    // Save data safely inside SharedPreferences
    await _blockerService.saveFocusSessionData(widget.taskTitle, widget.totalMinutes);
    
    await _playAlarm();
    if (mounted) setState(() {});
  }

  String formatTime() {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Future<void> _playAlarm() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource("sounds/notifications.mp3"));
  }

  @override
  void dispose() {
    timer?.cancel();
    NotificationService.cancelPanicNotification();
    _player.dispose();
    
    // Safety release: Always stop blocks if the screen is dismissed mid-run
    _blockerService.stopLockdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = remainingSeconds / (widget.totalMinutes * 60);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange,
                          size: 42,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Emergency Focus",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Forget everything else.\nOnly this task matters now.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    widget.taskTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 240,
                      height: 240,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 12,
                        backgroundColor: AppColors.progressBg,
                        color: AppColors.primary,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          formatTime(),
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Remaining",
                          style: TextStyle(color: AppColors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      timer?.cancel();
                      await _player.stop();
                      await NotificationService.cancelPanicNotification();
                      
                      // Stop blocking and log the elapsed minutes into SharedPreferences
                      await _blockerService.stopLockdown();
                      
                      // Calculate active duration spent focusing
                      int minutesCompleted = widget.totalMinutes - (remainingSeconds ~/ 60);
                      if (minutesCompleted > 0) {
                        await _blockerService.saveFocusSessionData(widget.taskTitle, minutesCompleted);
                      }

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "I Finished It",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}