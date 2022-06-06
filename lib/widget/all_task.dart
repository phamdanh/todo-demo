import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:todo/model/task_controller.dart';

import '../model/task.dart';
import 'task_card.dart';

class AllTask extends StatefulWidget {
  const AllTask({Key? key}) : super(key: key);

  @override
  State<AllTask> createState() => AllTaskState();
}

class AllTaskState extends State<AllTask> {

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, tasks, child) => FutureBuilder<List<Task>>(
        future: tasks.getAllTasks(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) => _listItemBuilder(snapshot.data![index]),
              padding: const EdgeInsets.all(15),
              itemCount: snapshot.data!.length,
            );
          }
          return Container();
        }
      ),
    );
  }

  Widget _listItemBuilder(Task task) {
    return TaskCard(
      key: UniqueKey(),
      task: task,
    );
  }
}
