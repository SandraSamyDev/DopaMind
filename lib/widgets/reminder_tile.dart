import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class ReminderTile extends StatelessWidget {
  const ReminderTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
          Icon(Icons.notifications, color: AppColors.primary),
          SizedBox(width: 10),
          Text("09:00 AM"),
        ],
      ),
    );
  }
}
