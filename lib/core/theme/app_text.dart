import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // 🔥 عنوان كبير (Task Title)
  static const title = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.dark,
  );

  // 🧾 نص عادي (Subtitles)
  static const subtitle = TextStyle(
    fontSize: 14,
    color: AppColors.grey,
  );

  // 🏷️ labels صغيرة (زي Start Date / Focus Mode)
  static const label = TextStyle(
    fontSize: 12,
    color: AppColors.grey,
  );

  // 💬 value جوه الكارد
  static const value = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.dark,
  );

  // ⚠️ priority text
  static const priority = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.highPriorityText,
  );
}
