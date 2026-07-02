import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'anxious_screen.dart';
import 'overwhelmed_screen.dart';
import 'low_energy_screen.dart';
import 'bored_screen.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Calm Corner",
          style: TextStyle(color: AppColors.dark, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "How are you feeling right now?",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Choose what matches your current state and we'll help.",
              style: TextStyle(color: AppColors.grey, fontSize: 14),
            ),
            const SizedBox(height: 30),
            _emotionCard(
              context,
              icon: Icons.psychology_alt_outlined,
              iconColor: const Color(0xFFF59E0B),
              title: "Overwhelmed",
              subtitle: "Too many thoughts and tasks",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OverwhelmedScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _emotionCard(
              context,
              icon: Icons.favorite_border,
              iconColor: const Color(0xFFEC4899),
              title: "Anxious",
              subtitle: "Feeling stressed or nervous",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AnxiousScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _emotionCard(
              context,
              icon: Icons.battery_0_bar,
              iconColor: const Color(0xFF3B82F6),
              title: "Low Energy",
              subtitle: "Everything feels hard to start",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LowEnergyScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _emotionCard(
              context,
              icon: Icons.sentiment_neutral_outlined,
              iconColor: const Color(0xFF8B5CF6),
              title: "Bored",
              subtitle: "Need a dopamine boost",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BoredScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _emotionCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: AppColors.grey)),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
