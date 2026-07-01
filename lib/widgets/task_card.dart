import 'package:dopamind/core/app_colors.dart';
import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task; // FIX: Updated from Task to TaskModel
  final VoidCallback onTap;

  const TaskCard({super.key, required this.task, required this.onTap});

  Color getPriorityColor() {
    switch (task.priority.toUpperCase()) {
      case "HIGH":
        return Colors.red.shade200;
      case "MEDIUM":
        return Colors.orange.shade200;
      case "LOW":
        return Colors.grey.shade300;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dynamically calculate steps from your subtasks list
    final int totalSteps = task.subtasks.length;
    final int completedSteps = task.subtasks.where((sub) => sub['isDone'] == true).length;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
        ),
        child: Row(
          children: [
            // Checkbox Indicator
            CircleAvatar(
              radius: 12,
              backgroundColor: task.isCompleted // FIX: changed to isCompleted
                  ? AppColors.primary
                  : Colors.grey.shade300,
              child: task.isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : CircleAvatar(radius: 10, backgroundColor: Colors.white),
            ),

            const SizedBox(width: 12),

            // Task Info Info Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  task.isCompleted
                      ? Text(
                          "Mode: ${task.focusMode}", // Displaying focus style on completion
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        )
                      : Text(
                          "$completedSteps/$totalSteps steps completed", // Computed dynamically!
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                ],
              ),
            ),
            // Priority Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: getPriorityColor(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                task.priority,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),

            // Context Menu Button
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'details') {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(task.title),
                      content: Text(
                        "Description: ${task.description}\n\n"
                        "Steps: $completedSteps/$totalSteps\n"
                        "Priority: ${task.priority}\n"
                        "Focus Mode: ${task.focusMode}",
                      ),
                    ),
                  );
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'details', child: Text("Show details")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}