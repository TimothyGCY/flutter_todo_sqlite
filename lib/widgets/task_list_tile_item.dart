import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey/database/repository.dart';
import 'package:todoey/models/task_model.dart';

class TaskListTileItem extends StatelessWidget {
  const TaskListTileItem({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return Consumer<Repository>(builder: (context, data, _) {
      return FutureBuilder(
          future: data.findTaskById(id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Task task = snapshot.data as Task;
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
                          await data.toggleDone(task);
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
                                final result = await data.deleteTask(id);
                                if (result != 0) {
                                  data.notifyListeners();
                                }
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
            return Container();
          });
    });
  }
}
