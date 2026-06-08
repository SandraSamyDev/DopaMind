import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:focusflow_new/core/theme/app_colors.dart ';
import 'package:focusflow_new/core/theme/app_text.dart ';

class AddSubtaskButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddSubtaskButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: AppColors.grey,
      strokeWidth: 1.5,
      dashPattern: [6, 3],
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.primary.withOpacity(0.1), // 👈 هنا

        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add, size: 18),
              SizedBox(width: 6),
              Text(
                "Add another step",
                style: AppTextStyles.subtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
