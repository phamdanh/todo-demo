import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/task.dart';

class DatabaseUtils {
  static final DatabaseUtils instance = DatabaseUtils._internal();
  DatabaseUtils._internal();
  factory DatabaseUtils() {
    return instance;
  }

  Database? _database;
  static const String taskTableName = 'MyTasks';

  Future<Database> _getDatabase() async {
    if(_database!= null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _getPath() async {
    var databasesPath = await getDatabasesPath();
    // Make sure the directory exists
    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (_) {}
    return join(databasesPath, 'tasks.db');
  }

  Future<Database> _initDatabase() async {
    String path = await _getPath();
    return await openDatabase(path, version: 1,
        onCreate: _createDatabase,
        onUpgrade: _onUpgradeDatabase,
        onDowngrade: onDatabaseDowngradeDelete);
  }

  Future _createDatabase(Database db, int version) async {
    await _createDataTables(db);
  }

  Future _onUpgradeDatabase(Database db, int oldVersion, int newVersion) async {
    if(newVersion > oldVersion) {

    }
  }

  Future _createDataTables(Database db) async {
    //create task table
    await db.execute('DROP TABLE IF EXISTS $taskTableName');
    await db.execute(
        'CREATE TABLE $taskTableName ('
            '${Task.idField} INTEGER PRIMARY KEY AUTOINCREMENT,'
            '${Task.nameField} TEXT NOT NULL,'
            '${Task.completedField} INTEGER NOT NULL,'
            '${Task.descriptionField} TEXT NOT NULL)'
    );
  }

  Future<int> createNewTask(String name, String description) async {
    Database db = await _getDatabase();
    return await db.insert(taskTableName, {Task.nameField: name, Task.descriptionField: description, Task.completedField: 0});
  }

  Future updateCompletedValue(int id, bool completed) async {
    Database db = await _getDatabase();
    await db.update(taskTableName, {Task.completedField: completed ? 1: 0},
        where: '${Task.idField} = $id');
  }

  Future<Task?> findTask(int id) async{
    Database db = await _getDatabase();
    final result = await db.query(taskTableName, where: '${Task.idField} = $id');
    List<Task> lists = result.map((e) => Task.fromJson(e)).toList();
    if(lists.isNotEmpty){
      return lists.first;
    }
    return null;
  }

  Future<List<Task>> getAllTasks() async{
    Database db = await _getDatabase();
    final result = await db.query(taskTableName);
    return result.map((e) => Task.fromJson(e)).toList();
  }

  Future<List<Task>> getCompletedTasks() async{
    Database db = await _getDatabase();
    final result = await db.query(taskTableName, where: '${Task.completedField} = 1');
    return result.map((e) => Task.fromJson(e)).toList();
  }

  Future<List<Task>> getIncompleteTasks() async{
    Database db = await _getDatabase();
    final result = await db.query(taskTableName, where: '${Task.completedField} = 0');
    return result.map((e) => Task.fromJson(e)).toList();
  }
}