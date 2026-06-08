import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class FlowModeCard extends StatelessWidget {
  const FlowModeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            "Suggested: 90min Deep Work session",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
