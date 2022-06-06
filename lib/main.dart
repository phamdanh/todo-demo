import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/data/database_utils.dart';

import 'model/task_controller.dart';
import 'widget/dialog/new_task_dialog.dart';
import 'model/task.dart';
import 'widget/all_task.dart';
import 'widget/complete_task.dart';
import 'widget/incomplete_task.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskController>(
      create: (context) => TaskController(DatabaseUtils()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TODO List',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: const MyHomePage(title: 'TODO List'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var taskController = Provider.of<TaskController>(context);
    return Container(
      color: Theme.of(context).cardColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('TODO List'),
          ),
          body: getBody(_selectedIndex),
          backgroundColor: Theme.of(context).backgroundColor,
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              boxShadow: <BoxShadow>[BoxShadow(color: Colors.black12, blurRadius: 2.0, offset: Offset(0.0, 0.2))],
            ),
            child: BottomNavigationBar(
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedFontSize: 16,
                type: BottomNavigationBarType.fixed,
                unselectedFontSize: 14,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.note_rounded), label: "All"),
                  BottomNavigationBarItem(icon: Icon(Icons.check_box), label: "Complete"),
                  BottomNavigationBarItem(icon: Icon(Icons.check_box_outline_blank), label: "Incomplete"),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed:() => _createNewTask(taskController),
            tooltip: "Create new task",
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  _createNewTask(TaskController taskController) async {
    Task? task = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const NewTaskDialog();
      },
    );
    if (task != null) {
      if (task.name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Name field can not be empty'),
          duration: Duration(seconds: 1),
        ));
      } else {
        await taskController.createNewTask(task.name, task.description);
      }
    }
  }

  Widget getBody(int index) {
    switch (index) {
      case 1:
        return CompleteTask();
      case 2:
        return IncompleteTask();
      default:
        return AllTask();
    }
  }
}
