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
  late int remainingSeconds;
  final BlockerService _blockerService = BlockerService();
  Timer? timer;
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    remainingSeconds = widget.totalMinutes * 60;

    NotificationService.showPanicNotification(
      taskTitle: widget.taskTitle,
      remaining: Duration(seconds: remainingSeconds),
    );

    startTimer();
    _enforceLockdown();
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
        await NotificationService.cancelPanicNotification();
        await _blockerService.stopLockdown();
        await _playAlarm();

        setState(() {});
      }
    });
  }

  Future<void> _enforceLockdown() async {
    try {
      await _blockerService.startLockdown();
    } catch (e) {
      debugPrint("Failed to start app lock: $e");
    }
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

                      await _blockerService.stopLockdown();

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
