import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef RegisterTodoCallback = void Function(
  String description,
  DateTime endDate,
);

class Register extends HookWidget {
  final RegisterTodoCallback registerTodo;
  const Register({super.key, required this.registerTodo});

  @override
  Widget build(BuildContext context) {
    final descriptionEditController = useTextEditingController();
    final selectedDate = useState<DateTime?>(null);

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        actions: [
          TextButton(
            onPressed: () {
              final date = selectedDate.value;
              if (date == null) return;
              registerTodo(descriptionEditController.text, date);
            },
            child: Text('Save'),
          ),
        ],
      ),
      body: Column(
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
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 360)),
            onDateSubmitted: (date) => selectedDate.value = date,
          ),
        ],
      ),
    );
  }
}
