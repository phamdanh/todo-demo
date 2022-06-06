import 'package:flutter/material.dart';

import '../../model/task.dart';

class NewTaskDialog extends StatefulWidget {
  const NewTaskDialog({Key? key}) : super(key: key);

  @override
  _NewTaskDialogState createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<NewTaskDialog> {
  String _name = '', _description = '';
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create new task", style: Theme.of(context).textTheme.headline5,),
      content: SizedBox(
        height: 180,
        child: Column(
          children: [
            TextFormField(
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Name',
                contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                isDense: true,
              ),
              controller: _nameController,
              onChanged:(value) => _name = value,
            ),
            const SizedBox(height: 10,),
            SizedBox(
              child: TextFormField(
                maxLines: 4,
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description',
                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  isDense: true,
                ),
                onChanged:(value) => _description = value,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Create"),
          onPressed: () {
            Navigator.pop(context, Task(id: 0, name: _name, description: _description));
          },
        )
      ],
      actionsPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
    );
  }
}