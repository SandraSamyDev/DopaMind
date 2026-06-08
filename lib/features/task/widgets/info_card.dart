import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: AppColors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                  color: AppColors.dark,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCardsRow extends StatelessWidget {
  final String focusMode;
  final DateTime dueDate;
  const InfoCardsRow(
      {super.key, required this.focusMode, required this.dueDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InfoCard(
          icon: Icons.calendar_today,
          color: AppColors.primary,
          title: "Start Date",
          value: "${dueDate.day}/${dueDate.month}/${dueDate.year}",
        ),
        SizedBox(width: 10),
        InfoCard(
          icon: Icons.flash_on,
          color: Color(0xFF9d4300),
          title: "Focus Mode",
          value: focusMode,
        ),
      ],
    );
  }
}
