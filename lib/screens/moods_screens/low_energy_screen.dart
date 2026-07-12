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
                "Change your physical workspace entirely when you're stuck. Punting yourself to a dedicated external spot like a library or cafe cuts down the heavy 'stuck at home' mental friction and boosts output without extra mental effort.",
                "Body Doubling: Utilize the presence of another person to help anchor your focus so your brain doesn't have to work as hard to stay present.",
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
                "Aim for a garbage run. If you only get 26% of a task done, that is still infinitely further along than if you never started",
                "Do a quick, dumb blast of cardio (like jumping jacks or dancing to one song) right before you need to sit down",
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
                "Remind yourself that future you is still you. They aren't going to magically possess a massive surge of motivation later. If you don't have the drive to do it within the next 24 hours, future you won't either",
                "Swap out screen rewards. Gamify the lack of motivation with immediate physical rewards instead, like eating a favorite snack etc... the second you finish a task ",
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
                "it's completely okay if the strategies or systems you tried today didn't work for you. It's not a personal failure.",
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
