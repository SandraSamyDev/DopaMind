import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'focus_screen.dart';

class TipsScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String intro;
  final List<String> tips;
  final String buttonText;

  const TipsScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.intro,
    required this.tips,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.dark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 10),

            Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: iconColor.withOpacity(.15),
                child: Icon(icon, size: 45, color: iconColor),
              ),
            ),

            const SizedBox(height: 25),

            Text(
              intro,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),

            const SizedBox(height: 30),

            ...tips.map(
              (tip) => Container(
                margin: const EdgeInsets.only(bottom: 14),

                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.primary),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Text(
                        tip,
                        style: const TextStyle(fontSize: 16, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.08),
                borderRadius: BorderRadius.circular(18),
              ),

              child: const Text(
                "Remember 💙\nSmall steps are still progress.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),

                onPressed: () {
                  if (buttonText == "Start Focus") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FocusScreen()),
                    );
                  } else {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                },

                child: Text(
                  buttonText,
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
