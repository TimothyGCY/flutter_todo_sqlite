import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey/database/repository.dart';
import 'database/sqlite_repository.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // sqlite database initialization
  Repository repository = SqliteRepository();
  await repository.init();

  runApp(MyApp(
    repository: repository,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.repository}) : super(key: key);

  final Repository repository;

  @override
  Widget build(BuildContext context) {
    const String title = 'Todoey';
    return ChangeNotifierProvider<Repository>(
      lazy: false,
      create: (context) => repository,
      builder: (context, _) => MaterialApp(
        title: title,
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        home: const HomeScreen(title: title),
      ),
    );
  }
}
