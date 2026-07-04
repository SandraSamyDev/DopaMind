import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final List<TaskModel> tasks = provider.tasks;

    final int totalTasks = tasks.length;
    final int completedTasks = tasks.where((task) => task.isCompleted).length;

    final int productivity = totalTasks == 0
        ? 0
        : ((completedTasks / totalTasks) * 100).round();

    final int longestSession = tasks.isEmpty
        ? 0
        : tasks.map((e) => e.durationMinutes).reduce((a, b) => a > b ? a : b);


    final int totalFocusMinutes = tasks.fold(
      0,
      (sum, task) => sum + task.actualTimeSpentMinutes,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Insights",
          style: TextStyle(color: AppColors.dark, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ===== Productivity Score =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text(
                    "Productivity Score",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "$productivity%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    productivity >= 80
                        ? "You're doing great!"
                        : productivity >= 50
                            ? "Keep going!"
                            : "Let's finish some tasks!",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ===== Stats Grid =====
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.15,
              children: [
                _buildStatCard(
                  title: "Tasks",
                  value: "$totalTasks",
                  icon: Icons.check_circle_outline,
                ),
                _buildStatCard(
                  title: "Total Focus",
                  value: "$totalFocusMinutes min", //  dynamic data spent
                  icon: Icons.local_fire_department_outlined,
                ),
                _buildStatCard(
                  title: "Sessions",
                  value: "$completedTasks",
                  icon: Icons.timer_outlined,
                ),
                _buildStatCard(
                  title: "Longest Target",
                  value: "$longestSession min",
                  icon: Icons.workspace_premium_outlined,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ===== Dynamic Task Summary Breakdown =====
            if (totalFocusMinutes > 0)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Time Spent Breakdown",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.dark),
                    ),
                    const SizedBox(height: 12),
                    ...tasks.where((t) => t.actualTimeSpentMinutes > 0).map((task) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(task.title, style: const TextStyle(color: AppColors.dark)),
                            Text(
                              "${task.actualTimeSpentMinutes} min",
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  static Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: AppColors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}