import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey/database/repository.dart';
import 'package:todoey/widgets/add_task_modal.dart';
import 'package:todoey/widgets/task_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Consumer<Repository>(
      builder: (context, data, _) {
        return FutureBuilder(
          future: data.undoneCount,
          builder: (context, snapshot) => Scaffold(
            backgroundColor: Colors.lightGreen,
            body: Container(
              padding: const EdgeInsets.only(top: 56.0),
              child: Stack(
                children: [
                  Positioned(
                    left: 36,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      child: const Icon(
                        Icons.list,
                        color: Colors.lightGreen,
                        size: 48,
                      ),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    left: 36,
                    top: 88,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 48,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 36,
                    top: (88 + 48 + 12),
                    child: Text(
                      '${snapshot.hasData ? snapshot.data : 0} Task(s)',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Positioned(
                    top: 200,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 256,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      constraints: const BoxConstraints(),
                      child: const TaskList(),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                String newTask = await showModalBottomSheet(
                  context: context,
                  builder: (context) => const AddTaskModal(),
                );

                if (newTask.isNotEmpty) {
                  int result = await data.insertTask(newTask);
                  if (result != 0) {
                    data.notifyListeners();
                  }
                }
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
