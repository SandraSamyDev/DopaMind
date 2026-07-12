import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/app_colors.dart';
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
    final int totalSessions = tasks.fold(
      0,
      (sum, task) => sum + task.focusSessions,
    );
    final int productivity = totalTasks == 0
        ? 0
        : ((completedTasks / totalTasks) * 100).round();

    final int longestSession = tasks.isEmpty
        ? 0
        : tasks
              .map((e) => e.actualTimeSpentMinutes)
              .reduce((a, b) => a > b ? a : b);
    final int totalFocusMinutes = tasks.fold(
      0,
      (sum, task) => sum + task.actualTimeSpentMinutes,
    );
    // ===== Calculate Daily Completion Streak =====
// 1. Extract all valid completion dates (ignoring time) into a sorted unique set
final uniqueCompletionDates = tasks
    .where((task) => task.isCompleted && task.completedAt != null)
    .map((task) => DateTime(task.completedAt!.year, task.completedAt!.month, task.completedAt!.day))
    .toSet()
    .toList()
  ..sort((a, b) => b.compareTo(a)); // Newest first

int streakCount = 0;
final now = DateTime.now();
final today = DateTime(now.year, now.month, now.day);
final yesterday = today.subtract(const Duration(days: 1));

// 2. Check if the user completed a task today or yesterday to keep the streak alive
bool isStreakAlive = uniqueCompletionDates.contains(today) || uniqueCompletionDates.contains(yesterday);

if (isStreakAlive) {
  // Start checking backwards from the most recent active completion day
  DateTime anchorDay = uniqueCompletionDates.contains(today) ? today : yesterday;
  
  while (uniqueCompletionDates.contains(anchorDay)) {
    streakCount++;
    anchorDay = anchorDay.subtract(const Duration(days: 1));
  }
}

    // Filter out top 4 tasks with the most focus time for a clean chart display
    final List<TaskModel> chartTasks =
        tasks.where((t) => t.actualTimeSpentMinutes > 0).toList()..sort(
          (a, b) =>
              b.actualTimeSpentMinutes.compareTo(a.actualTimeSpentMinutes),
        );
    final displayChartTasks = chartTasks.take(4).toList();

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

            // ===== Visual Chart Section =====
            if (displayChartTasks.isNotEmpty) ...[
              _buildVisualChartCard(displayChartTasks),
              const SizedBox(height: 24),
            ],

            // ===== Stats Grid =====

            // ===== Streak Banner =====
Container(
  width: double.infinity,
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  margin: const EdgeInsets.only(bottom: 16),
  decoration: BoxDecoration(
    color: Colors.amber.shade50,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.amber.shade200, width: 1),
  ),
  child: Row(
    children: [
      Icon(Icons.local_fire_department_rounded, color: Colors.orange.shade700, size: 28),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$streakCount Day ${streakCount == 1 ? 'Streak' : 'Streak!'}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange.shade900),
            ),
            Text(
              streakCount > 0 ? "Fantastic consistency! Keep the fire burning." : "Complete a task today to start a new streak!",
              style: TextStyle(fontSize: 12, color: Colors.orange.shade800),
            ),
          ],
        ),
      ),
    ],
  ),
),
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
                  value: "$totalFocusMinutes min",
                  icon: Icons.local_fire_department_outlined,
                ),
                _buildStatCard(
                  title: "Sessions",
                  value: "$totalSessions",
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...tasks.where((t) => t.actualTimeSpentMinutes > 0).map((
                      task,
                    ) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                task.title,
                                style: const TextStyle(color: AppColors.dark),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "${task.actualTimeSpentMinutes} min",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
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

  // Beautiful modern bar chart representing the time allocation per task
  static Widget _buildVisualChartCard(List<TaskModel> chartTasks) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Focus Time Allocation",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Minutes spent per top task",
            style: TextStyle(fontSize: 12, color: AppColors.grey),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY:
                    chartTasks
                        .map((e) => e.actualTimeSpentMinutes.toDouble())
                        .reduce((a, b) => a > b ? a : b) *
                    1.2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) =>
                        AppColors.dark.withValues(alpha: 0.9),
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        "${rod.toY.round()} min",
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < chartTasks.length) {
                          String title = chartTasks[index].title;
                          if (title.length > 8)
                            title = "${title.substring(0, 6)}..";

                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              title,
                              style: const TextStyle(
                                color: AppColors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(chartTasks.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: chartTasks[index].actualTimeSpentMinutes
                            .toDouble(),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0.6),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: 18,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
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