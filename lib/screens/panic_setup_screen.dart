import 'package:flutter/material.dart';
import '../core/app_text.dart';
import '../core/app_colors.dart';
import 'panic_focus_screen.dart';

class PanicSetupScreen extends StatefulWidget {
  final String taskTitle;

  const PanicSetupScreen({super.key, required this.taskTitle});

  @override
  State<PanicSetupScreen> createState() => _PanicSetupScreenState();
}

class _PanicSetupScreenState extends State<PanicSetupScreen> {
  String selectedTime = "30 min";

  final TextEditingController taskController = TextEditingController();
  @override
  void initState() {
    super.initState();

    taskController.text = widget.taskTitle;
  }

  int get durationMinutes {
    switch (selectedTime) {
      case "15 min":
        return 15;

      case "30 min":
        return 30;

      case "1 hour":
        return 60;

      case "2 hours":
        return 120;

      default:
        return 30;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "Emergency Focus",
          style: TextStyle(color: AppColors.dark, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      size: 46,
                      color: Colors.orange,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "Panic Mode",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Forget everything else.\nFocus on this task until it's done.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.flash_on_rounded, color: Colors.orange),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Only this task matters now.",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "How much time is left?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                timeChip("15 min"),
                timeChip("30 min"),
                timeChip("1 hour"),
                timeChip("2 hours"),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "What must be done?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: taskController,
              readOnly: true,

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: () {
                  if (taskController.text.isEmpty) {
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PanicFocusScreen(
                        taskTitle: taskController.text,
                        totalMinutes: durationMinutes,
                      ),
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow_rounded, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Start Emergency Session",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
  }

  Widget timeChip(String value) {
    final selected = selectedTime == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = value;
        });
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),

        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,

          borderRadius: BorderRadius.circular(14),
        ),

        child: Text(
          value,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
