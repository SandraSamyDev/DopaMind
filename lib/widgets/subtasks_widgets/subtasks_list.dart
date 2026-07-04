import 'package:flutter/material.dart';
import 'subtask_item.dart';

class SubtasksList extends StatelessWidget {
  final List<Map<String, dynamic>> subtasks;
  final Function(int) onToggle;
  final VoidCallback? onAddSubtask;

  const SubtasksList({
    super.key,
    required this.subtasks,
    required this.onToggle,
    this.onAddSubtask,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Subtasks (${subtasks.where((task) => task['done'] == true).length}/${subtasks.length})",
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...subtasks.asMap().entries.map(
          (entry) {
            final task = entry.value;

            return SubtaskItem(
              title: task["title"] as String,
              isDone: task["done"] as bool,
              onTap: () => onToggle(entry.key),
            );
          },
        ),
      ],
    );
  }
}
