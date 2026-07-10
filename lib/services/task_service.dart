import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get taskRef =>
      _firestore.collection('users').doc(uid).collection('tasks');

  Future<void> addTask(TaskModel task) async {
    if (kDebugMode) {
      print("Inside addTask");
    }
    await taskRef.doc(task.id).set(task.toMap());
  }

  Stream<List<TaskModel>> getTasks() {
    return taskRef.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) {
        return TaskModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList(),
    );
  }

  // Future<void> updateTask(TaskModel task) async {
  //   if (task.id.isEmpty) {
  //     if (kDebugMode) {
  //       print("Task id is empty");
  //     }
  //     return;
  //   }
  //   print("Updating task ${task.title}");
  //   print("Focus Sessions = ${task.focusSessions}");
  //   print("Minutes = ${task.actualTimeSpentMinutes}");
  //   await taskRef.doc(task.id).update(task.toMap());
  // }
  Future<void> updateTask(TaskModel task) async {
    print("Updating Firestore...");
    print(task.toMap());

    await taskRef.doc(task.id).update(task.toMap());

    print("Firestore updated");
  }

  Future<void> deleteTask(String id) async {
    await taskRef.doc(id).delete();
  }

  Future<void> logTimeSpent(String taskId, int minutesJustSpent) async {
    final docRef = FirebaseFirestore.instance.collection('tasks').doc(taskId);

    await docRef.update({
      'actualTimeSpentMinutes': FieldValue.increment(minutesJustSpent),
    });
  }
}
