import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../tips_screen.dart';

class OverwhelmedScreen extends StatelessWidget {
  const OverwhelmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Overwhelmed",
          style: TextStyle(color: AppColors.dark, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 20),

            const Center(
              child: Icon(
                Icons.psychology_alt,
                size: 70,
                color: Color(0xffF59E0B),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "What's making today feel difficult?",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Choose what feels closest to your situation.",
              style: TextStyle(color: AppColors.grey),
            ),

            const SizedBox(height: 35),

            buildOption(
              context,
              Icons.checklist,
              "Too many tasks",
              "Let's simplify things.",
              const Color(0xff3B82F6),
              [
                "Write everything down.",
                "Choose ONE task only.",
                "Ignore the rest for now.",
                "You can come back later.",
              ],
              "I picked one task",
            ),

            const SizedBox(height: 16),

            buildOption(
              context,
              Icons.warning_amber,
              "Everything feels urgent",
              "Let's slow everything down.",
              const Color(0xffF59E0B),
              [
                "Take one deep breath.",
                "Not everything needs to be done now.",
                "Choose the single most urgent thing.",
                "Everything else can wait.",
              ],
              "I'm Ready",
            ),

            const SizedBox(height: 16),

            buildOption(
              context,
              Icons.play_arrow,
              "I don't know where to start",
              "Starting is harder than doing.",
              const Color(0xff10B981),
              [
                "Pick the easiest thing.",
                "Work for only 5 minutes.",
                "Don't aim for perfect.",
                "Once you start, momentum will help.",
              ],
              "Let's Start",
            ),

            const SizedBox(height: 16),
            buildOption(
              context,
              Icons.phone_android,
              "I keep getting distracted",
              "Let's remove distractions.",
              const Color(0xff6366F1),
              [
                "Start a Focus Session.",
                "Block distracting apps.",
                "Keep your phone away for 15 minutes.",
                "Focus on only ONE thing.",
              ],
              "Start Focus",
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOption(
    BuildContext context,
    IconData icon,
    String title,
    String intro,
    Color iconColor,
    List<String> tips,
    String buttonText,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TipsScreen(
              title: title,
              icon: icon,
              iconColor: iconColor,
              intro: intro,
              tips: tips,
              buttonText: buttonText,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}
