import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../models/task_model.dart';
import '../widgets/subtask_item.dart';
import '../widgets/task_header.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
// import '../../../services/gemini_service.dart';
import 'task_details_screen.dart';
import '../models/task_model.dart';

class TaskEditorScreen extends StatefulWidget {
  final TaskModel task;

  const TaskEditorScreen({super.key, required this.task});

  @override
  State<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends State<TaskEditorScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  List<Map<String, dynamic>> subtasks = [];

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String selectedPriority = "High";
  String selectedFocusMode = "Deep Work";
  bool isGeneratingAI = false;
  String selectedEnergy = "Medium";
  String selectedDetail = "Medium";
  String selectedTimeSlot = "30 min";
  String goblinStep = "";

  void openAIBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome, color: AppColors.primary),
                        const SizedBox(width: 8),
                        const Text(
                          "AI Assistant",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      "Turn overwhelm into a clear plan",
                      style: TextStyle(color: AppColors.grey, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Energy Level",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _energyChip("Low", setModalState),
                      _energyChip("Medium", setModalState),
                      _energyChip("High", setModalState),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Detail Level",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _detailChip("Simple", setModalState),
                      _detailChip("Medium", setModalState),
                      _detailChip("Detailed", setModalState),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Available Time",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _timeChip("5 min", setModalState),
                      _timeChip("15 min", setModalState),
                      _timeChip("30 min", setModalState),
                      _timeChip("1 hour", setModalState),
                      _timeChip("No Limit", setModalState),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        generateAITasks();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Generate Plan",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> generateAITasks() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter task title first")));
      return;
    }

    setState(() {
      isGeneratingAI = true;
    });

    try {
      final task = titleController.text.toLowerCase();

      List<String> generatedSteps = [];

      if ((task.contains("flutter") ||
          task.contains("app") ||
          task.contains("project") ||
          task.contains("coding"))) {
        generatedSteps = [
          "Open the project",
          "Review current UI",
          "Implement one screen",
          "Test functionality",
          "Commit changes",
        ];
      } else if (task.contains("study") ||
          task.contains("exam") ||
          task.contains("math") ||
          task.contains("learn") ||
          task.contains("lecture")) {
        generatedSteps = [
          "Open study materials",
          "Read first section",
          "Write key notes",
          "Solve 3 exercises",
          "Review mistakes",
        ];
      } else if (task.contains("design") || task.contains("ui")) {
        generatedSteps = [
          "Collect inspiration",
          "Create wireframe",
          "Choose colors",
          "Design main screen",
          "Review consistency",
        ];
      } else {
        generatedSteps = [
          "Understand the task",
          "Prepare resources",
          "Start first small step",
          "Complete main work",
          "Review progress",
        ];
      }
      if (selectedEnergy == "Low") {
        generatedSteps = generatedSteps.take(3).toList();
      } else if (selectedEnergy == "Medium") {
        generatedSteps = generatedSteps.take(5).toList();
      } else {
        generatedSteps = generatedSteps;
      }
      if (selectedTimeSlot == "5 min") {
        generatedSteps = generatedSteps.take(2).toList();
      } else if (selectedTimeSlot == "15 min") {
        generatedSteps = generatedSteps.take(3).toList();
      } else if (selectedTimeSlot == "30 min") {
        generatedSteps = generatedSteps.take(5).toList();
      }
      if (selectedDetail == "Simple") {
        generatedSteps = generatedSteps.take(3).toList();
      } else if (selectedDetail == "Medium") {
        generatedSteps = generatedSteps.take(5).toList();
      } else if (selectedDetail == "Detailed") {
        generatedSteps.addAll(["Check quality", "Optimize results"]);
      }

      setState(() {
        subtasks.addAll(
          generatedSteps.map((step) => {"title": step, "done": false}),
        );

        isGeneratingAI = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
          elevation: 0,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "AI plan generated successfully",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      print("ERROR: $e");

      setState(() {
        isGeneratingAI = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text("AI Error: $e"),
        ),
      );
    }
  }

  void generateGoblinStep() {
    final task = titleController.text.toLowerCase();

    if (task.contains("study") ||
        task.contains("lecture") ||
        task.contains("exam")) {
      final steps = [
        "Open the lecture only",
        "Read one page only",
        "Read one paragraph only",
        "Write one note only",
      ];

      steps.shuffle();
      goblinStep = steps.first;
    } else if (task.contains("flutter") ||
        task.contains("project") ||
        task.contains("coding")) {
      final steps = [
        "Open the project only",
        "Run the app only",
        "Open one file only",
        "Fix one tiny bug",
      ];

      steps.shuffle();
      goblinStep = steps.first;
    } else if (task.contains("design") ||
        task.contains("ui") ||
        task.contains("figma")) {
      final steps = [
        "Open Figma only",
        "Look at one screen only",
        "Choose one color only",
        "Fix one design issue",
      ];

      steps.shuffle();
      goblinStep = steps.first;
    } else {
      goblinStep = "Work on it for just 2 minutes";
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.psychology_alt_rounded,
                    color: AppColors.primary,
                    size: 34,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Goblin Mode",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Don't finish the task.\nJust do this:",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.grey),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    goblinStep,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Got it",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

  @override
  void initState() {
    super.initState();

    titleController.text = widget.task.title;

    descriptionController.text = "";

    selectedDate = widget.task.dueDate;

    selectedTime = widget.task.reminder;

    selectedPriority = widget.task.priority;

    selectedFocusMode = widget.task.focusMode;

    subtasks = List<Map<String, dynamic>>.from(widget.task.subtasks);
  }

  void addSubtaskDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_task_rounded,
                    color: AppColors.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Add New Subtask",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Create a new step for this task",
                  style: TextStyle(color: AppColors.grey),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Enter subtask name",
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.text.trim().isNotEmpty) {
                            setState(() {
                              subtasks.add({
                                "title": controller.text.trim(),
                                "done": false,
                              });
                            });

                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Add",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void toggleSubtask(int index) {
    setState(() {
      subtasks[index]["done"] = !subtasks[index]["done"];
    });
  }

  void deleteSubtask(int index) {
    setState(() {
      subtasks.removeAt(index);
    });
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.dark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.dark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  Future<void> saveTask() async {
    print("SAVE PRESSED");
    final updatedTask = TaskModel(
      id: widget.task.id,
      title: titleController.text,
      description: descriptionController.text,
      priority: selectedPriority,
      focusMode: selectedFocusMode,
      dueDate: selectedDate ?? DateTime.now(),
      reminder: selectedTime ?? TimeOfDay.now(),
      subtasks: subtasks,
      durationMinutes: widget.task.durationMinutes,
      blockedAppsPackages: widget.task.blockedAppsPackages,
      isCompleted: widget.task.isCompleted,
      completedAt: widget.task.completedAt,
    );

    try {
      print("Before provider");
      await context.read<TaskProvider>().saveTask(updatedTask);

      print("After provider");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Task saved")));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TaskDetailsScreen(task: updatedTask)),
      );
    } catch (e) {
      print(e);
    }
  }

  Widget _priorityChip(String value) {
    final isSelected = selectedPriority == value;

    Color bgColor;
    Color textColor;

    switch (value) {
      case "Low":
        bgColor = const Color(0xFFE8F5E9);
        textColor = Colors.green;
        break;

      case "Medium":
        bgColor = const Color(0xFFFFF3E0);
        textColor = Colors.orange;
        break;

      default:
        bgColor = AppColors.highPriorityBg;
        textColor = AppColors.highPriorityText;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPriority = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? bgColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? textColor : Colors.grey.shade300,
          ),
        ),
        child: Text(
          value.toUpperCase(),
          style: TextStyle(
            color: isSelected ? textColor : Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _energyChip(String value, StateSetter setModalState) {
    final isSelected = selectedEnergy == value;

    return GestureDetector(
      onTap: () {
        setModalState(() {
          selectedEnergy = value;
        });

        setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _detailChip(String value, StateSetter setModalState) {
    final isSelected = selectedDetail == value;

    return GestureDetector(
      onTap: () {
        setModalState(() {
          selectedDetail = value;
        });

        setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _timeChip(String value, StateSetter setModalState) {
    final isSelected = selectedTimeSlot == value;

    return GestureDetector(
      onTap: () {
        setModalState(() {
          selectedTimeSlot = value;
        });

        setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color getPriorityBgColor() {
    switch (selectedPriority.toLowerCase().trim()) {
      case "low":
        return const Color(0xFFE8F5E9);

      case "medium":
        return const Color(0xFFFFF3E0);

      default:
        return AppColors.highPriorityBg;
    }
  }

  Color getPriorityTextColor() {
    switch (selectedPriority.toLowerCase().trim()) {
      case "low":
        return Colors.green;

      case "medium":
        return Colors.orange;

      default:
        return AppColors.highPriorityText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        leadingWidth: 36,
        iconTheme: const IconThemeData(color: AppColors.primary),
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: const Text(
          "Task Editor",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: saveTask,
            child: const Text(
              "Save",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            /// Priority
            /// Priority
            ///
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: getPriorityBgColor(),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                selectedPriority.toUpperCase(),
                style: TextStyle(
                  color: getPriorityTextColor(),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 12),
            const Text(
              "Task Name",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.grey,
              ),
            ),

            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: titleController,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.dark,
                  height: 1.2,
                ),
                decoration: const InputDecoration(
                  hintText: "Task Title",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 18),
            const Text(
              "Priority",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.grey,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                _priorityChip("Low"),
                const SizedBox(width: 8),
                _priorityChip("Medium"),
                const SizedBox(width: 8),
                _priorityChip("High"),
              ],
            ),

            const SizedBox(height: 18),

            /// Title

            /// Date (clickable كله)
            InkWell(
              onTap: pickDate,
              child: SectionTile(
                icon: Icons.calendar_today,
                title: "DUE DATE",
                value: selectedDate == null
                    ? "Oct 24, 2023"
                    : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
              ),
            ),
            const SizedBox(height: 12),

            /// Time (clickable كله)
            InkWell(
              onTap: pickTime,
              child: SectionTile(
                icon: Icons.notifications,
                title: "REMINDER",
                value: selectedTime == null
                    ? "09:00 AM"
                    : selectedTime!.format(context),
              ),
            ),

            const SizedBox(height: 14),

            /// Description
            const Text(
              "Notes (Optional)",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.grey,
              ),
            ),

            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: descriptionController,
                maxLines: 4,
                minLines: 4,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.dark,
                ),
                decoration: const InputDecoration(
                  hintText: "Add anything helpful...",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: AppColors.primary),
                      const SizedBox(width: 8),
                      const Text(
                        "Feeling Overwhelmed?",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Let us build a realistic plan based on your energy and available time",
                    style: TextStyle(color: AppColors.grey),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isGeneratingAI ? null : openAIBottomSheet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isGeneratingAI
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Generate Steps",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.psychology_alt_rounded,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Goblin Mode",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Can't start? Let's make it ridiculously easy.",
                    style: TextStyle(color: AppColors.grey),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: generateGoblinStep,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Give Me One Tiny Step",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Subtasks
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Subtasks (${subtasks.where((task) => task["done"] == true).length}/${subtasks.length})",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
                GestureDetector(
                  onTap: addSubtaskDialog,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Column(
              children: List.generate(subtasks.length, (index) {
                return Stack(
                  children: [
                    SubtaskItem(
                      title: subtasks[index]["title"],
                      isDone: subtasks[index]["done"],
                      onTap: () => toggleSubtask(index),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: AppColors.grey,
                          size: 20,
                        ),
                        onPressed: () => deleteSubtask(index),
                      ),
                    ),
                  ],
                );
              }),
            ),

            const SizedBox(height: 18),

            /// Flow Mode
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Flow Mode", style: TextStyle(color: Colors.white)),
                  SizedBox(height: 4),
                  Text(
                    "Suggested: 90min Deep Work session",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// 🔥
      /// Bottom Navigation
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 1,
      //   selectedItemColor: AppColors.primary,
      //   unselectedItemColor: Colors.grey,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.center_focus_strong),
      //       label: "Focus",
      //     ),
      //     BottomNavigationBarItem(icon: Icon(Icons.check_box), label: "Tasks"),
      //     BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Flow"),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.settings),
      //       label: "Settings",
      //     ),
      //   ],
      // ),
    );
  }
}

/// Tag Widget
class TagChip extends StatelessWidget {
  final String label;
  final Color color;

  const TagChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: color)),
    );
  }
}

/// Section Tile
class SectionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const SectionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 86),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
