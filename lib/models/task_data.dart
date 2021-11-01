import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:todoey/models/task_model.dart';
import 'package:uuid/uuid.dart';

class TaskData extends ChangeNotifier {
  final List<Task> _taskList = [];

  void addTask(String title) {
    _taskList.add(Task(title: title, id: const Uuid().v4().replaceAll(RegExp('-'), '')));
    notifyListeners();
  }

  void toggleDone(int index) {
    _taskList[index].completed = !taskList[index].completed;
    notifyListeners();
  }

  void removeTask(int index) {
    _taskList.removeAt(index);
    notifyListeners();
  }

  Task getTask(int index) => taskList[index];

  /// Using UnmodifiableListView<> instead of List<>
  /// to prevent user using back default data customization
  /// method such as add() or remove() in List<> but
  /// instead have them use the custom method created
  /// within this class.
  UnmodifiableListView<Task> get taskList => UnmodifiableListView(_taskList);

  int get undoneCount => taskList.where((task) => !task.completed).length;
}
