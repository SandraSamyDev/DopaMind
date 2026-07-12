// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import '../../widgets/tasks_widgets/task_header.dart';
import '../../widgets/progress_section.dart';
import '../../widgets/info_card.dart';
import '../../widgets/subtasks_widgets/subtasks_list.dart';
import '../../../../core/app_colors.dart';
import 'task_editor_screen.dart';
import '../../models/task_model.dart';
import '../../widgets/tasks_widgets/task_button.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../focus_screen.dart';
import '../panic_screens/panic_setup_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  final TaskModel task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late TaskModel task;

  @override
  void initState() {
    super.initState();
    task = widget.task;
  }

  final DateTime dueDate = DateTime.now().add(const Duration(days: 2));

  int get completedTasks =>
      task.subtasks.where((task) => task['done'] == true).length;

  double get progress =>
      task.subtasks.isEmpty ? 0 : completedTasks / task.subtasks.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Task Details",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.dark),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Delete Task"),
                  content: const Text(
                    "Are you sure you want to delete this task?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm != true) return;

              await context.read<TaskProvider>().deleteTask(task.id);

              if (!mounted) return;

              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TaskHeader(
                    dueDate: task.dueDate,
                    reminder: task.reminder,
                    title: task.title,
                    priority: task.priority,
                  ),
                  const SizedBox(height: 20),
                  ProgressSection(progress: progress),
                  const SizedBox(height: 20),
                  InfoCardsRow(
                    focusMode: task.focusMode,
                    dueDate: task.dueDate,
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xffFFF4E5),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Panic Mode",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        const Text(
                          "Deadline is getting close?\nFocus on this task only.",
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PanicSetupScreen(
                                    taskTitle: task.title,
                                    blockedAppsFromTask: [],
                                  ),
                                ),
                              );
                            },
                            child: const Text("Start Panic Mode"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: progress == 1
                        ? Container(
                            key: const ValueKey("completed"),
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.celebration,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Task Completed!",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text("You've completed all subtasks."),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  SubtasksList(
                    subtasks: task.subtasks,
                    onToggle: (index) async {
                      setState(() {
                        task.subtasks[index]["done"] =
                            !(task.subtasks[index]["done"] as bool);

                        task.isCompleted = task.subtasks.every(
                          (s) => s["done"] == true,
                        );
                      });

                      await context.read<TaskProvider>().updateTask(task);
                    },
                    onAddSubtask: () {},
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.timer),
                    label: const Text("Start Focus Session"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FocusScreen(
                            task: task.copyWith(
                              durationMinutes: task.durationMinutes == 0
                                  ? 45
                                  : task.durationMinutes,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: AppColors.primary.withValues(alpha: 0.08),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () async {
                              final updatedTask = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TaskEditorScreen(task: task),
                                ),
                              );

                              if (updatedTask != null) {
                                setState(() {
                                  task = updatedTask;
                                });

                                await context.read<TaskProvider>().updateTask(
                                  updatedTask,
                                );
                              }
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit_outlined,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Edit Task",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: TaskButton(
                        isCompleted: progress == 1,
                        onTap: () async {
                          setState(() {
                            for (var subtask in task.subtasks) {
                              subtask["done"] = true;
                            }
                            task.isCompleted = true;
                          });

                          await context.read<TaskProvider>().updateTask(task);

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
