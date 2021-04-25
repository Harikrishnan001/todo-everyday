import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';

class SQLDatabase {
  final dbName = 'todo';
  final colId = 'id';
  final colStartTime = 'startTime';
  final colEndTime = 'endTime';
  final colTask = 'task';
  final colDescription = 'description';
  final colIsDone = 'isDone';
  final colShouldRemind = 'shouldRemind';
  final tableReminder = 'reminder';
  final int version = 1;
  static Database _db;

  static SQLDatabase _singleTon = SQLDatabase._internal();

  SQLDatabase._internal();
  factory SQLDatabase() {
    return _singleTon;
  }

  Future init() async {
    final parentDir = await getApplicationDocumentsDirectory();
    final dir = join(parentDir.path, dbName + '.db');
    _db = await openDatabase(dir, version: 1,
        onCreate: (database, version) async {
      final sql =
          "CREATE TABLE $tableReminder ($colId INTEGER PRIMARY KEY,$colStartTime INT ,$colEndTime INT,$colTask TEXT,$colDescription TEXT,$colIsDone INT,$colShouldRemind INT)";
      await database.execute(sql);
    });
  }

  Future<int> insertTask(Task task) async {
    final result = await _db.insert(tableReminder, task.toMap());
    return result;
  }

  Future<int> removeTask(Task task) async {
    final result = await _db.delete(
      tableReminder,
      where: "$colId = ?",
      whereArgs: [task.id],
    );
    return result;
  }

  Future<int> updateTask(Task task) async {
    if (task == null) print("Task is null");
    if (task.isDone == null) print("is done is null");
    if (task.shouldRemind == null) print("remind is null");
    if (task.endTime == null) print("endTime is null");
    if (task.startTime == null) print("starttime is null");
    if (task.id == null) print("id is null");
    if (task.task == null) print("task name is null");

    final result = await _db.update(tableReminder, task.toMap(),
        where: '$colId = ?', whereArgs: [task.id]);
    return result;
  }

  Future<List<Task>> getAllTasks() async {
    final list = await _db.query(
      tableReminder,
      orderBy: colEndTime,
    );
    return list.map((map) => Task.fromMap(map)).toList();
  }

  Future<List<Task>> getUnfinishedTasks() async {
    if (_db == null) await init();
    final list = await _db.query(
      tableReminder,
      where: '$colIsDone=?',
      whereArgs: ['0'],
      orderBy: colEndTime,
    );
    return list.map((map) => Task.fromMap(map)).toList();
  }

  Future<List<Task>> getFinishedTasks() async {
    final list = await _db.query(
      tableReminder,
      where: '$colIsDone=?',
      whereArgs: ['1'],
      orderBy: colEndTime,
    );
    return list.map((map) => Task.fromMap(map)).toList();
  }

  Future<void> closeDatabase() async {
    await _db.close();
  }
}
