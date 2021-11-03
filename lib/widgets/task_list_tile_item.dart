import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey/database/repository.dart';
import 'package:todoey/database/sqlite_repository.dart';
import 'package:todoey/models/task_model.dart';

class TaskListTileItem extends StatelessWidget {
  const TaskListTileItem({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    final SqliteRepository repo = SqliteRepository();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: task.completed,
              onChanged: (b) async {
                task.toggleDone();
                await repo.toggleDone(task);
              },
            ),
            Text(
              task.title,
              style: TextStyle(
                color: task.completed ? Colors.grey : Colors.black,
                decoration: task.completed
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete task?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await repo.deleteTask(task.id);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }
}
