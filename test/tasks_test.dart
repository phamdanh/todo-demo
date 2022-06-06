import 'package:test/test.dart';
import 'package:todo/data/database_utils.dart';
import 'package:todo/model/task.dart';
import 'package:todo/model/task_controller.dart';

class MockDatabaseUtils implements DatabaseUtils {
  late List<Task> _tasks;
  MockDatabaseUtils(){
    _tasks = [];
  }
  int _uniqueId = 0;
  @override
  Future<int> createNewTask(String name, String description) async {
    _uniqueId++;
    _tasks.add(Task(id: _uniqueId, name: name, description: description, completed: 0));
    return _uniqueId;
  }

  @override
  updateCompletedValue(int id, bool completed) async {
    for(Task task in _tasks){
      if(task.id == id) {
        task.completed = completed ? 1: 0;
        break;
      }
    }
  }

  @override
  Future<List<Task>> getAllTasks() async {
    return _tasks;
  }

  @override
  Future<Task?> findTask(int id) async {
    List<Task> results = _tasks.where((element) => element.id == id).toList();
    if(results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  @override
  Future<List<Task>> getCompletedTasks() async {
    return _tasks.where((element) => element.completed == 1).toList();
  }

  @override
  Future<List<Task>> getIncompleteTasks() async{
    return _tasks.where((element) => element.completed == 0).toList();
  }
}

void main() {
  late MockDatabaseUtils mockDatabase;
  late TaskController taskController;

  group('Testing TaskController', () {
    mockDatabase = MockDatabaseUtils();
    taskController = TaskController(mockDatabase);

    test('test findTaskById method', () async {
      Task? task = await taskController.findTaskById(0);
      expect(task == null, true);
    });

    test('test createNewTask method', () async {
      int id = await taskController.createNewTask("task 1", "description 1");
      Task? task = await taskController.findTaskById(id);
      expect(task?.name, "task 1");
      int id2 = await taskController.createNewTask("", "");
      expect(id2, -1); ///return -1 (task creation is failed)
    });

    test('test getAllTasks method', () async {
      List<Task> tasks = await taskController.getAllTasks();
      expect(tasks.length, 1);
    });

    test('test updateTaskCompleted method', () async {
      int id = await taskController.createNewTask("task 2", "description 2");
      Task? task = await taskController.findTaskById(id);
      if(task != null) {
        expect(task.completed, 0);
        await taskController.updateTaskCompleted(id, true);
        expect(task.completed, 1);
      }
    });

    test('test getIncompleteTasks method', () async {
      List<Task> tasks = await taskController.getIncompleteTasks();
      expect(tasks.length, 1);
    });

    test('test getCompletedTasks method', () async {
      List<Task> tasks = await taskController.getCompleteTasks();
      expect(tasks.length, 1);
    });

  });
}
