import 'package:flutter/material.dart';
import 'package:focusflow_new/core/theme/app_colors.dart';

class ProgressSection extends StatelessWidget {
  final double progress;

  const ProgressSection({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = progress == 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Task Progress",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14,
              ),
            ),
            Text(
              "${(progress * 100).round()}%",
              style: TextStyle(
                color: isCompleted
                    ? Colors.green
                    : AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),

        Container(
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.progressBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Align(
              alignment: Alignment.centerLeft,
              child:TweenAnimationBuilder<double>(
  duration: const Duration(milliseconds: 500),
  tween: Tween(
    begin: 0,
    end: progress,
  ),
  builder: (context, value, child) {
    return FractionallySizedBox(
      widthFactor: value,
      child: child,
    );
  },
  child: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: isCompleted
            ? [
                Colors.green,
                Colors.greenAccent,
              ]
            : [
                AppColors.primary,
                AppColors.progressValue,
              ],
      ),
    ),
  ),
              ),
            )
          ),
        ),
      ],
    );
  }
}
