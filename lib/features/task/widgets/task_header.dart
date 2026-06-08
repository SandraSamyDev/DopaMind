import 'package:flutter/material.dart';
import 'package:focusflow_new/core/theme/app_colors.dart';
import 'package:focusflow_new/core/theme/app_text.dart ';

class TaskHeader extends StatelessWidget {
  final DateTime dueDate;
  final TimeOfDay reminder;
  final String title;
  final String priority;
  const TaskHeader(
      {super.key,
      required this.dueDate,
      required this.reminder,
      required this.title,
      required this.priority});
  DateTime get fullDueDateTime {
    return DateTime(
      dueDate.year,
      dueDate.month,
      dueDate.day,
      reminder.hour,
      reminder.minute,
    );
  }

  String getDueStatus() {
    final now = DateTime.now();

    final target = fullDueDateTime;

    if (target.isBefore(now)) {
      return "🔴 Overdue";
    }

    final difference = target.difference(now);

    if (difference.inDays > 0) {
      return "🟢 ${difference.inDays} day${difference.inDays > 1 ? "s" : ""} left";
    }

    if (difference.inHours > 0) {
      return "🟠 ${difference.inHours}h left";
    }

    if (difference.inMinutes > 0) {
      return "🟠 ${difference.inMinutes}m left";
    }

    return "⚠ Due now";
  }

  Color getPriorityBgColor() {
    switch (priority.toLowerCase()) {
      case "low":
        return const Color(0xFFE8F5E9);

      case "medium":
        return const Color(0xFFFFF3E0);

      default:
        return AppColors.highPriorityBg;
    }
  }

  Color getPriorityTextColor() {
    switch (priority.toLowerCase()) {
      case "low":
        return Colors.green;

      case "medium":
        return Colors.orange;

      default:
        return AppColors.highPriorityText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: getPriorityBgColor(),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            priority.toUpperCase(),
            style: TextStyle(
                color: getPriorityTextColor(), fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: AppTextStyles.title,
        ),
        const SizedBox(height: 8),
        Text(
          getDueStatus(),
          style: AppTextStyles.subtitle,
        ),
      ],
    );
  }
}
