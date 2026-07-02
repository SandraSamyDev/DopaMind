import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'tips_screen.dart';

class BoredScreen extends StatelessWidget {
  const BoredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Bored",
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
                Icons.sentiment_neutral_outlined,
                size: 70,
                color: Color(0xff8B5CF6),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Need a little dopamine?",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Choose something that sounds fun right now.",
              style: TextStyle(color: AppColors.grey),
            ),

            const SizedBox(height: 35),

            buildOption(
              context,
              Icons.music_note,
              "Listen to Music",
              "A favorite song can instantly change your mood.",
              const Color(0xffEC4899),
              [
                "Play your favorite song.",
                "Dance or move for one minute.",
                "Smile if you can.",
                "Enjoy the moment.",
              ],
              "Feeling Better",
            ),

            const SizedBox(height: 16),

            buildOption(
              context,
              Icons.language,
              "Learn Something New",
              "Your brain loves novelty.",
              const Color(0xff3B82F6),
              [
                "Learn one word in a new language.",
                "Watch a 5-minute educational video.",
                "Read one interesting fact.",
                "Curiosity creates motivation.",
              ],
              "That Was Fun",
            ),

            const SizedBox(height: 16),

            buildOption(
              context,
              Icons.directions_walk,
              "Go for a Short Walk",
              "Movement helps reset your brain.",
              const Color(0xff10B981),
              [
                "Walk for 5-10 minutes.",
                "Get some fresh air.",
                "Stretch while walking.",
                "Come back feeling refreshed.",
              ],
              "I'm Refreshed",
            ),

            const SizedBox(height: 16),

            buildOption(
              context,
              Icons.palette_outlined,
              "Try a New Hobby",
              "Doing something creative wakes up your brain.",
              const Color(0xffF59E0B),
              [
                "Draw something small.",
                "Read a few pages of a book.",
                "Take a nice photo.",
                "Cook or try a simple recipe.",
              ],
              "Let's Go",
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
