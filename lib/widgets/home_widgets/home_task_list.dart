import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../tasks_widgets/task_card.dart';

class HomeTaskList extends StatelessWidget {
  final List tasks;

  const HomeTaskList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          task: task,
          onTap: () async {
            final newStatus = !task.isCompleted;

            task.isCompleted = newStatus;
            task.completedAt = newStatus ? DateTime.now() : null;

            for (var subtask in task.subtasks) {
              subtask["done"] = newStatus;
            }

            await context.read<TaskProvider>().updateTask(task);
          },
        );
      },
    );
  }
}
