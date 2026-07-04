import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../tips_screen.dart';

class LowEnergyScreen extends StatelessWidget {
  const LowEnergyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Low Energy",
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
                Icons.battery_0_bar,
                size: 70,
                color: Color(0xff3B82F6),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "What's draining your energy?",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Let's make today a little easier.",
              style: TextStyle(color: AppColors.grey),
            ),

            const SizedBox(height: 35),

            buildOption(
              context,
              Icons.hotel,
              "I'm mentally exhausted",
              "Your brain needs a gentle reset.",
              const Color(0xff3B82F6),
              [
                "Drink a glass of water.",
                "Stretch for one minute.",
                "Take three slow breaths.",
                "Then come back and do one tiny task.",
              ],
              "I'm Ready",
            ),

            const SizedBox(height: 16),

            buildOption(
              context,
              Icons.play_circle_outline,
              "I can't get started",
              "Let's lower the pressure.",
              const Color(0xff10B981),
              [
                "Forget finishing.",
                "Work for only 2 minutes.",
                "Starting is enough.",
                "You can stop after that if you want.",
              ],
              "Let's Start",
            ),

            const SizedBox(height: 16),

            buildOption(
              context,
              Icons.music_note,
              "I need motivation",
              "Let's boost your dopamine.",
              const Color(0xffEC4899),
              [
                "Play your favorite song.",
                "Open a sunny window.",
                "Reward yourself after a small step.",
                "Celebrate tiny wins.",
              ],
              "Feeling Better",
            ),

            const SizedBox(height: 16),

            buildOption(
              context,
              Icons.favorite_outline,
              "I feel like giving up",
              "Be kind to yourself.",
              const Color(0xff8B5CF6),
              [
                "You're not lazy.",
                "Your energy changes, and that's okay.",
                "Doing something small is enough today.",
                "Progress is still progress.",
              ],
              "I'll Keep Going",
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
      borderRadius: BorderRadius.circular(20),

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
