import 'package:dopamind/core/app_colors.dart';
import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskCard({super.key, required this.task, required this.onTap});

  Color getPriorityColor() {
    switch (task.priority) {
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
            CircleAvatar(
              radius: 12,
              backgroundColor: task.isDone
                  ? AppColors.primary
                  : Colors.transparent,
              child: task.isDone
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  task.isDone
                      ? Text(
                          "Completed at ${task.time}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        )
                      : Text(
                          "${task.completedSteps}/${task.totalSteps} steps completed",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: getPriorityColor(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(task.priority, style: const TextStyle(fontSize: 10)),
            ),

            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'details') {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(task.title),
                      content: Text(
                        "Steps: ${task.completedSteps}/${task.totalSteps}\nPriority: ${task.priority}",
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
