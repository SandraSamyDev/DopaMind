import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class DatePickerTile extends StatelessWidget {
  const DatePickerTile({super.key});

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
          Icon(Icons.calendar_today, color: AppColors.primary),
          SizedBox(width: 10),
          Text("Oct 24, 2023"),
        ],
      ),
    );
  }
}
