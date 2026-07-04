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

  const TaskCategory({
    required this.name,
    required this.icon,
    required this.color,
  });
}

// Inside your model file:
class TaskModel {
  // Change this from TaskModel to Task
  String title;
  String description;
  String priority;
  String focusMode;
  DateTime dueDate;
  TimeOfDay reminder;
  List<Map<String, dynamic>> subtasks;
  int actualTimeSpentMinutes;
  

  final String id;
  int durationMinutes;
  bool isCompleted;
  DateTime? completedAt;

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
    
    this.isCompleted = false,
    this.completedAt,
    this.actualTimeSpentMinutes = 0,
  });

  TaskModel copyWith({
    String? title,
    String? description,
    String? priority,
    String? focusMode,
    DateTime? dueDate,
    TimeOfDay? reminder,
    List<Map<String, dynamic>>? subtasks,
    int? actualTimeSpentMinutes,
    String? id,
    int? durationMinutes,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return TaskModel(
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      focusMode: focusMode ?? this.focusMode,
      dueDate: dueDate ?? this.dueDate,
      reminder: reminder ?? this.reminder,
      subtasks: subtasks ?? this.subtasks,
      actualTimeSpentMinutes: actualTimeSpentMinutes ?? this.actualTimeSpentMinutes,
      id: id ?? this.id,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'focusMode': focusMode,
      'dueDate': dueDate.toIso8601String(),
      'reminderHour': reminder.hour,
      'reminderMinute': reminder.minute,
      'subtasks': subtasks,
      'actualTimeSpentMinutes': actualTimeSpentMinutes ,
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      priority: map['priority'],
      focusMode: map['focusMode'],
      dueDate: DateTime.parse(map['dueDate']),
      reminder: TimeOfDay(
        hour: map['reminderHour'],
        minute: map['reminderMinute'],
      ),
      subtasks: List<Map<String, dynamic>>.from(map['subtasks']),
      durationMinutes: map['durationMinutes'],
      actualTimeSpentMinutes: map['actualTimeSpentMinutes'] ?? 0,
      isCompleted: map['isCompleted'],
      completedAt: map['completedAt'] != null
    ? DateTime.parse(map['completedAt'])
    : null,
    );
  }
}
