import 'package:dopamind/widgets/task_duration_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../models/task_model.dart';
import '../../widgets/subtasks_widgets/subtask_item.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
// import '../../../services/gemini_service.dart';
import 'task_details_screen.dart';

class TaskEditorScreen extends StatefulWidget {
  final TaskModel task;
  const TaskEditorScreen({super.key, required this.task});

  @override
  State<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends State<TaskEditorScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  String selectedPriority = "Medium";
  String selectedEnergy = "Medium";
  String selectedDetail = "Normal";
  String selectedTimeSlot = "Morning";
  String? selectedFocusMode;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int selectedDurationTime=25;

  List<Map<String, dynamic>> subtasks = [];
  bool isGeneratingAI = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(
      text: widget.task.description,
    );
    selectedPriority = widget.task.priority;
    selectedFocusMode = widget.task.focusMode;
    selectedDate = widget.task.dueDate;
    selectedTime = widget.task.reminder;
    selectedDurationTime = widget.task.durationMinutes;
    subtasks = List<Map<String, dynamic>>.from(
      widget.task.subtasks.map((item) => Map<String, dynamic>.from(item)),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(bool isDate) async {
    if (isDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      );
      if (date != null) setState(() => selectedDate = date);
    } else {
      final time = await showTimePicker(
        context: context,
        initialTime: selectedTime ?? TimeOfDay.now(),
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.dark,
            ),
          ),
          child: child!,
        ),
      );
      if (time != null) setState(() => selectedTime = time);
    }
  }

  Future<void> saveTask() async {
    final updatedTask = TaskModel(
      id: widget.task.id,
      title: titleController.text,
      description: descriptionController.text,
      priority: selectedPriority,
      focusMode: selectedFocusMode ?? "",
      dueDate: selectedDate ?? DateTime.now(),
      reminder: selectedTime ?? TimeOfDay.now(),
      subtasks: subtasks,
      durationMinutes: widget.task.durationMinutes,
      isCompleted: widget.task.isCompleted,
      completedAt: widget.task.completedAt,
    );

    try {
      await context.read<TaskProvider>().saveTask(updatedTask);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Task saved")));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TaskDetailsScreen(task: updatedTask)),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _showAddSubtaskDialog() {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "New Subtask",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: const InputDecoration(hintText: "What needs to be done?"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                setState(() {
                  subtasks.add({
                    "title": textController.text.trim(),
                    "done": false,
                  });
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _triggerGoblinMode() {
    final incomplete = subtasks.where((t) => t["done"] == false).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.psychology_alt_rounded,
          size: 40,
          color: AppColors.primary,
        ),
        title: const Text(
          "Your One Tiny Step",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          incomplete.isEmpty
              ? "No pending subtasks! Add some subtasks first or enjoy your clean slate."
              : "Don't think about the rest. Just do this single thing:\n\n👉  \"${incomplete.first['title']}\"",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "I'm on it!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _openAIBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "AI Strategy Settings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18),
              const Text(
                "Current Energy Level",
                style: TextStyle(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildSelectionChip(
                    "Low",
                    selectedEnergy,
                    (v) =>
                        setModalState(() => setState(() => selectedEnergy = v)),
                  ),
                  const SizedBox(width: 8),
                  _buildSelectionChip(
                    "Medium",
                    selectedEnergy,
                    (v) =>
                        setModalState(() => setState(() => selectedEnergy = v)),
                  ),
                  const SizedBox(width: 8),
                  _buildSelectionChip(
                    "High",
                    selectedEnergy,
                    (v) =>
                        setModalState(() => setState(() => selectedEnergy = v)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // Add your network API / LLM response processor trigger connection here
                  },
                  child: const Text(
                    "Generate Custom Schedule",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDurationPicker() {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return TaskDurationPicker(
        initialDuration: Duration(minutes: selectedDurationTime),
        onDurationChanged: (Duration totalDuration) {
          setState(() {

            selectedDurationTime = totalDuration.inMinutes;
          });
        },
      );
    },
  );
}

String _formatDurationDisplay(int totalMinutes) {
  if (totalMinutes == 0) return "Not set";
  final int hours = totalMinutes ~/ 60;
  final int minutes = totalMinutes % 60;
  
  if (hours > 0) {
    return "$hours hr ${minutes > 0 ? '$minutes min' : ''}";
  }
  return "$minutes min";
}

  // Consolidated Priority styling map
  Map<String, Color> get _priorityColors {
    switch (selectedPriority.toLowerCase().trim()) {
      case "low":
        return {"bg": const Color(0xFFE8F5E9), "text": Colors.green};
      case "medium":
        return {"bg": const Color(0xFFFFF3E0), "text": Colors.orange};
      default:
        return {
          "bg": AppColors.highPriorityBg,
          "text": AppColors.highPriorityText,
        };
    }
  }

  // Generic Reusable Filter Chip Builder
  Widget _buildSelectionChip(
    String value,
    String currentValue,
    Function(String) onSelected,
  ) {
    final isSelected = currentValue == value;
    return GestureDetector(
      onTap: () => onSelected(value),
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

  Widget _priorityChip(String value) {
    final isSelected = selectedPriority == value;
    final colors = selectedPriority == "Low"
        ? {"bg": const Color(0xFFE8F5E9), "txt": Colors.green}
        : selectedPriority == "Medium"
        ? {"bg": const Color(0xFFFFF3E0), "txt": Colors.orange}
        : {"bg": AppColors.highPriorityBg, "txt": AppColors.highPriorityText};

    return GestureDetector(
      onTap: () => setState(() => selectedPriority = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors["bg"] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colors["txt"]! : Colors.grey.shade300,
          ),
        ),
        child: Text(
          value.toUpperCase(),
          style: TextStyle(
            color: isSelected ? colors["txt"] : Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _priorityColors["bg"],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                selectedPriority.toUpperCase(),
                style: TextStyle(
                  color: _priorityColors["text"],
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
            InkWell(
              onTap: () => _selectDateTime(true),
              child: SectionTile(
                icon: Icons.calendar_today,
                title: "DUE DATE",
                value: selectedDate == null
                    ? "Oct 24, 2023"
                    : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _selectDateTime(false),
              child: SectionTile(
                icon: Icons.notifications,
                title: "REMINDER",
                value: selectedTime == null
                    ? "09:00 AM"
                    : selectedTime!.format(context),
              ),
            ),
            const SizedBox(height: 12),
            
            InkWell(
              onTap: _showDurationPicker,
              child: SectionTile(
                icon: Icons.timer_outlined,
                title: "TARGET DURATION",
                value: _formatDurationDisplay(selectedDurationTime),
              ),
            ),

            const SizedBox(height: 18),

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
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 18),
            _buildActionCard(
              Icons.auto_awesome,
              "Feeling Overwhelmed?",
              "Let us build a realistic plan based on your energy and available time",
              "Generate Steps",
              isGeneratingAI,
              () {},
            ),
            const SizedBox(height: 18),
            _buildActionCard(
              Icons.psychology_alt_rounded,
              "Goblin Mode",
              "Can't start? Let's make it ridiculously easy.",
              "Give Me One Tiny Step",
              false,
              () {},
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Subtasks (${subtasks.where((t) => t["done"] == true).length}/${subtasks.length})",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
                GestureDetector(
                  onTap: _showAddSubtaskDialog, // Add subtask
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
            ...List.generate(subtasks.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Stack(
                  children: [
                    SubtaskItem(
                      title: subtasks[index]["title"],
                      isDone: subtasks[index]["done"],
                      onTap: () => setState(
                        () => subtasks[index]["done"] =
                            !(subtasks[index]["done"] ?? false),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.grey,
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => subtasks.removeAt(index)),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Flow Mode",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
    );
  }

  // Refactored helper to instantly clean up both massive AI/Goblin block sections
  Widget _buildActionCard(
    IconData icon,
    String title,
    String subtitle,
    String buttonText,
    bool loading,
    VoidCallback target,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: AppColors.grey)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: loading ? null : target,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

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
      padding: const EdgeInsets.all(18),
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
