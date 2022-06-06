import 'package:flutter/cupertino.dart';
import 'package:todo/data/database_utils.dart';
import 'package:todo/model/task.dart';

class TaskController extends ChangeNotifier {
  late DatabaseUtils _dataUtils;
  TaskController(DatabaseUtils dataUtils) {
    _dataUtils = dataUtils;
  }

  Future<int> createNewTask(String name, String description) async {
    if(name.trim().isNotEmpty) {
      int id = await _dataUtils.createNewTask(name, description);
      notifyListeners();
      return id;
    }
    return -1;
  }

  Future updateTaskCompleted(int id, bool completed) async {
    await _dataUtils.updateCompletedValue(id, completed);
    notifyListeners();
  }

  ///return null if task is not found
  Future<Task?> findTaskById(int id) async {
    return await _dataUtils.findTask(id);
  }

  Future<List<Task>> getAllTasks() async {
    return await _dataUtils.getAllTasks();
  }

  Future<List<Task>>  getIncompleteTasks() async {
    return await _dataUtils.getIncompleteTasks();
  }

  Future<List<Task>> getCompleteTasks() async {
    return await _dataUtils.getCompletedTasks();
  }
}