import 'package:flutter/material.dart';
import 'package:todoey/database/sqlite_repository.dart';
import 'package:todoey/models/task_model.dart';
import 'package:todoey/widgets/empty_list.dart';
import 'task_list_tile_item.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const EmptyList();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
                'Something goes wrong, refer as below\n${snapshot.error.toString()}'),
          );
        }

        List<Task> tasks = snapshot.data;
        if (tasks.isEmpty) return const EmptyList();
        return ListView.builder(
          padding: const EdgeInsets.all(24.0),
          itemBuilder: (context, index) => TaskListTileItem(task: tasks[index]),
          itemCount: tasks.length,
        );
      },
      stream: SqliteRepository().watchAllTasks(),
    );
  }
}
