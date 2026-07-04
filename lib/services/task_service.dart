import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

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
    return taskRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) {
          return TaskModel.fromMap(
            doc.data() as Map<String, dynamic>,
          );
        }).toList());
  }

  Future<void> updateTask(TaskModel task) async {
    if (task.id.isEmpty) {
    if (kDebugMode) {
      print("General session completed: No task associated. Skipping database update.");  
        return; 
    }
    else{
          await taskRef.doc(task.id).update(task.toMap());
    }

  }

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