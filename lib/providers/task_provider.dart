import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import 'dart:async';

class TaskProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  StreamSubscription? _tasksSubscription;

  List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;

  void listenToTasks() {
    _tasksSubscription?.cancel();

    _tasksSubscription = _taskService.getTasks().listen((tasksList) {
      _tasks = tasksList;
      notifyListeners();
    });
  }

  Future<void> addTask(TaskModel task) async {
    if (kDebugMode) {
      print("inside provider addTask");
    }
    await _taskService.addTask(task);
  }

  Future<void> updateTask(TaskModel task) async {
    await _taskService.updateTask(task);
  }

  Future<void> deleteTask(String id) async {
    await _taskService.deleteTask(id);
  }

  Future<void> saveTask(TaskModel task) async {
    if (kDebugMode) {
      print("inside provider");
    }
    final exists = _tasks.any((t) => t.id == task.id);

    if (exists) {
      await updateTask(task);
    } else {
      await addTask(task);
    }
  }

  void clearTasks() {
    _tasks = [];
    _tasksSubscription?.cancel();
    notifyListeners();
  }


}
