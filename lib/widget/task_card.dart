import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/model/task_controller.dart';
import '../model/task.dart';

class TaskCard extends StatefulWidget {
  final Task task;

  const TaskCard({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late bool _completed;

  @override
  void initState() {
    super.initState();
    _completed = widget.task.completed == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.task.name, style: Theme.of(context).textTheme.bodyLarge),
                  Text(widget.task.description, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Checkbox(
              value: _completed,
              onChanged: onCheckedChanged,
            ),
          ],
        ),
      ),
    );
  }

  onCheckedChanged(bool? value) {
    setState(() {
      _completed = value!;
    });
    Provider.of<TaskController>(context, listen: false).updateTaskCompleted(widget.task.id, _completed);
  }
}
