import 'package:flutter/material.dart';

// 1. Strongly-typed Categories with visual properties baked right in
enum TaskCategory {
  study(name: 'Study', icon: Icons.book, color: Colors.blue),
  work(name: 'Work', icon: Icons.business_center, color: Colors.orange),
  health(name: 'Health', icon: Icons.favorite, color: Colors.green),
  creative(name: 'Creative', icon: Icons.palette, color: Colors.purple);

  final String name;
  final IconData icon;
  final Color color;

  const TaskCategory({required this.name, required this.icon, required this.color});
}

// Inside your model file:
class TaskModel {  // Change this from TaskModel to Task
  String title;
  String description;
  String priority;
  String focusMode;
  DateTime dueDate;
  TimeOfDay reminder;
  List<Map<String, dynamic>> subtasks;
  
  final String id;
  int durationMinutes;
  List<String> blockedAppsPackages;
  bool isCompleted;

  TaskModel({
    required this.title,
    required this.description,
    required this.priority,
    required this.focusMode,
    required this.dueDate,
    required this.reminder,
    required this.subtasks,
    required this.id,
    required this.durationMinutes,
    required this.blockedAppsPackages,
    this.isCompleted = false,
  });
}