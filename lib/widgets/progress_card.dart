import 'package:dopamind/core/app_colors.dart';
import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final int done;
  final int total;

  const ProgressCard({super.key, required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    double progress = done / total;

    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFFECF0F3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "$done",
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(width: 4),
              Column(
                children: [
                  SizedBox(height: 15),
                  Text(
                    "of $total",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.flash_on, color: Colors.orange),
              ),
            ],
          ),

          const SizedBox(height: 16),

          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            borderRadius: BorderRadius.circular(10),
            color: AppColors.primary,
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}
