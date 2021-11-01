import 'package:todoey/database/database_helper.dart';
import 'package:todoey/models/task_model.dart';
import 'package:uuid/uuid.dart';

import 'repository.dart';

class SqliteRepository extends Repository {
  final dbHelper = DatabaseHelper.instance;

  @override
  void close() {
    dbHelper.close();
  }

  @override
  Future<int> deleteTask(String id) {
    return dbHelper.deleteTask(id);
  }

  @override
  Future<List<Task>> findAllTasks() {
    return dbHelper.findAllTasks();
  }

  @override
  Future<Task> findTaskById(String id) {
    return dbHelper.findTaskById(id);
  }

  @override
  Future<int> get undoneCount async {
    return await dbHelper.undoneCount;
  }

  @override
  Future init() async {
    await dbHelper.database;
    return Future.value();
  }

  @override
  Future<int> insertTask(String title) {
    return dbHelper.insertTask(
        Task(title: title, id: const Uuid().v4().replaceAll(RegExp('-'), '')));
  }

  @override
  Stream<List<Task>> watchAllTasks() {
    return dbHelper.watchAllTasks();
  }

  @override
  Future<int> toggleDone(Task task) {
    // TODO: implement toggleDone
    throw UnimplementedError();
  }
}
