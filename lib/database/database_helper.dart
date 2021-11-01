import 'package:path_provider/path_provider.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:path/path.dart';
import 'package:todoey/models/task_model.dart';

class DatabaseHelper {
  static const _databaseName = 'MyTasks.db';
  static const _databaseVersion = 1;

  // table name
  static const taskTable = 'Task';

  // column name
  static const taskId = 'taskId';
  static const done = 'done';

  // using late indicate variable is non-null and will be initialized after it's declared
  static late BriteDatabase _streamDatabase;

  // make a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static var lock = Lock();

  // only have a single app-wide reference to database
  static Database? _database;

  // create database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $taskTable (
      $taskId VARCHAR(50) PRIMARY KEY,
      title TEXT,
      done BOOLEAN
    )
    ''');

    // continue use db.execute() if there is/are more table(s)
  }

  // opening database
  Future<Database> _initDatabase() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, _databaseName);

    // turn this off for production
    Sqflite.setDebugModeOn(true);

    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    await lock.synchronized(() async {
      if (_database == null) {
        _database = await _initDatabase();
        _streamDatabase = BriteDatabase(_database!);
      }
    });
    return _database!;
  }

  Future<BriteDatabase> get streamDatabase async {
    await database;
    return _streamDatabase;
  }

  List<Task> parseTaskFromDatabase(List<Map<String, dynamic>> taskList) {
    final tasks = <Task>[];

    for (var taskItem in taskList) {
      final task = Task.fromJson(taskItem);
      tasks.add(task);
    }
    return tasks;
  }

  Future<List<Task>> findAllTasks() async {
    final db = await instance.streamDatabase;
    final taskList = await db.query(taskTable);
    final tasks = parseTaskFromDatabase(taskList);
    return tasks;
  }

  Stream<List<Task>> watchAllTasks() async* {
    final db = await instance.streamDatabase;

    // yield* create a stream using query
    yield* db.createQuery(taskTable).mapToList((row) => Task.fromJson(row));
  }

  // find by single item
  Future<Task> findTaskById(String id) async {
    final db = await instance.streamDatabase;
    final taskList = await db.query(taskTable, where: '$taskId = ?', whereArgs: [id]);
    final tasks = parseTaskFromDatabase(taskList);
    return tasks.first;
  }

  Future<int> get undoneCount async {
    final db = await instance.streamDatabase;
    final taskList =
        await db.query(taskTable, where: '$done = 0'); // 0 : false | 1 : true
    final tasks = parseTaskFromDatabase(taskList);
    return tasks.length;
  }

  // insert data into database
  Future<int> _insert(String table, Map<String, dynamic> row) async {
    final db = await instance.streamDatabase;
    return db.insert(table, row);
  }

  Future<int> insertTask(Task task) => _insert(taskTable, task.toJson());

  // delete data from database
  Future<int> _delete(String table, String columnId, String id) async {
    final db = await instance.streamDatabase;
    return db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteTask(String id) => _delete(taskTable, taskId, id);

  Future<int> _update(String table, String column, String id,
      Map<String, dynamic> newValue) async {
    final db = await instance.streamDatabase;
    return db.update(table, newValue, where: '$column = ?', whereArgs: [id]);
  }

  Future<int> toggleDone(Task task) =>
      _update(taskTable, taskId, task.id, task.toJson());

  void close() {
    _streamDatabase.close();
  }
}
