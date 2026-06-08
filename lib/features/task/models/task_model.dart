import 'package:flutter/material.dart';

class TaskModel {
  String title;
  String description;
  String priority;
  String focusMode;

  DateTime dueDate;
  TimeOfDay reminder;

  List<Map<String, dynamic>> subtasks;

  TaskModel({
    required this.title,
    required this.description,
    required this.priority,
    required this.focusMode,
    required this.dueDate,
    required this.reminder,
    required this.subtasks,
  });
}