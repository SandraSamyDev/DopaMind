import 'package:flutter/material.dart';
import 'package:focusflow_new/core/theme/app_colors.dart';

class SubtaskItem extends StatelessWidget {
  final String title;
  final bool isDone;
  final VoidCallback onTap;

  const SubtaskItem({
    super.key,
    required this.title,
    required this.isDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isDone ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.primary),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: isDone ? FontWeight.normal : FontWeight.w600,
                  color: isDone ? AppColors.grey : AppColors.dark,
                  decoration:
                      isDone ? TextDecoration.lineThrough : TextDecoration.none,
                  decorationThickness: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
