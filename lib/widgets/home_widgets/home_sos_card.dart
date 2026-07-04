import 'package:dopamind/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:dopamind/core/app_colors.dart';
import '../../screens/moods_screens/sos_screen.dart';

class HomeSosCard extends StatelessWidget {
  const HomeSosCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite_outline, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Feeling overwhelmed?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  "Take a moment. We'll guide you.",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          CustomButton(
            text: "Help",
            backgroundColor: AppColors.primary,
            verticalPadding: 8, // Sleeker padding for inline card buttons
            borderRadius: 8,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SosScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
