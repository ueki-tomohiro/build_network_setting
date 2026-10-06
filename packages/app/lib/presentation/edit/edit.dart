import 'package:external_todo/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef EditTodoCallback = void Function(
  String description,
  DateTime endDate,
  bool completed,
);

class Edit extends HookWidget {
  final Todo todo;
  final EditTodoCallback updateTodo;
  const Edit({super.key, required this.todo, required this.updateTodo});

  @override
  Widget build(BuildContext context) {
    final descriptionEditController = useTextEditingController(
      text: todo.description,
    );
    final selectedDate = useState<DateTime?>(todo.endDate);
    final completed = useState<bool>(todo.completed);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
        actions: [
          TextButton(
            onPressed: () {
              final date = selectedDate.value;
              if (date == null) return;
              updateTodo(descriptionEditController.text, date, completed.value);
            },
            child: Text('Update'),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: descriptionEditController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                hintText: 'description',
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            InputDatePickerFormField(
              firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
              lastDate: DateTime.now().add(Duration(days: 360)),
              initialDate: selectedDate.value,
              onDateSubmitted: (date) => selectedDate.value = date,
            ),
            CheckboxListTile(
              title: Text('completed'),
              value: true,
              onChanged: (isComplete) {
                completed.value = isComplete == true;
              },
            ),
          ],
        ),
      ),
    );
  }
}
