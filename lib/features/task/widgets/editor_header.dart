import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class EditorHeader extends StatelessWidget {
  const EditorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.highPriorityBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text("High Priority"),
        ),
        const SizedBox(height: 8),
        const Text(
          "Morning Deep Work Session",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
