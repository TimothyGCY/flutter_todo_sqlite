import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey/database/repository.dart';
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
    return Consumer<Repository>(
      builder: (context, data, child) => FutureBuilder(
        future: data.findAllTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Task> taskList = snapshot.data as List<Task>;
            if (taskList.isEmpty) {
              return const EmptyList();
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(24.0),
                itemBuilder: (context, index) {
                  return TaskListTileItem(id: taskList[index].id);
                },
                itemCount: taskList.length,
              );
            }
          } else {
            return const EmptyList();
          }
        },
      ),
    );
  }
}
