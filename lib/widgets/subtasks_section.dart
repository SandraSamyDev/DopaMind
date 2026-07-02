import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class SubtasksSection extends StatelessWidget {
  const SubtasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Subtasks"),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text("Add a subtask..."),
        ),
      ],
    );
  }
}
