import 'package:flutter/foundation.dart';
import 'package:todoey/models/task_model.dart';

abstract class Repository extends ChangeNotifier {
  Future<List<Task>> findAllTasks();

  Stream<List<Task>> watchAllTasks();

  Future<Task> findTaskById(String id);

  Future<int> get undoneCount;

  Future<int> insertTask(String title);

  Future<int> deleteTask(String id);

  Future<int> toggleDone(Task task);

  Future init();
  void close();

}