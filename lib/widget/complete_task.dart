import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:todo/widget/task_card.dart';

import '../model/task.dart';
import '../model/task_controller.dart';

class CompleteTask extends StatefulWidget {
  const CompleteTask({Key? key}) : super(key: key);

  @override
  State<CompleteTask> createState() => CompleteTaskState();
}

class CompleteTaskState extends State<CompleteTask> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, tasks, child) => FutureBuilder<List<Task>>(
          future: tasks.getCompleteTasks(),
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
