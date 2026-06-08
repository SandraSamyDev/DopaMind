import 'package:flutter/material.dart';
import '../widgets/task_header.dart';
import '../widgets/progress_section.dart';
import '../widgets/info_card.dart';
import '../widgets/subtasks_list.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/gradient_button.dart';
import '../screens/task_editor_screen.dart';
import '../models/task_model.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late TaskModel task;

  @override
  void initState() {
    super.initState();

    task = TaskModel(
      title: "Design System Review",
      description: "Project Lumina",
      priority: "High",
      focusMode: "Deep Work",
      dueDate: dueDate,
      reminder: const TimeOfDay(
        hour: 17,
        minute: 0,
      ),
      subtasks: [
        {
          "title": "Initial color palette audit",
          "done": true,
        },
        {
          "title": "Accessibility contrast check",
          "done": true,
        },
        {
          "title": "Finalize typography",
          "done": false,
        },
      ],
    );
  }

  final DateTime dueDate = DateTime.now().add(
    const Duration(days: 2),
  );

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
        iconTheme: const IconThemeData(
          color: AppColors.dark,
        ),
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
                  ProgressSection(
                    progress: progress,
                  ),
                  const SizedBox(height: 20),
                  InfoCardsRow(
                    focusMode: task.focusMode,
                    dueDate: task.dueDate,
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
                              color: AppColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.2),
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
                                      Text(
                                        "You've completed all subtasks.",
                                      ),
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
                    onToggle: (index) {
                      setState(() {
                        task.subtasks[index]["done"] =
                            !(task.subtasks[index]["done"] as bool);
                      });
                    },
                    onAddSubtask: () {},
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: AppColors.primary.withOpacity(0.08),
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
                              builder: (context) => TaskEditorScreen(
                                task: task,
                              ),
                            ),
                          );

                          if (updatedTask != null) {
                            setState(() {
                              task = updatedTask;
                            });
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
                  child: GradientButton(
                    isCompleted: progress == 1,
                    onTap: () {
                      setState(() {
                        for (var subtask in task.subtasks) {
                          subtask["done"] = true;
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.edit_note_rounded,
                  size: 60,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Edit Task",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Task editing will be available soon.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text(
                      "Got it",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddSubtaskDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Step"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter subtask title",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    task.subtasks.add({
                      "title": controller.text.trim(),
                      "done": false,
                    });
                  });

                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
