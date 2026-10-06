import 'package:external_todo/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TodoListItem extends HookWidget {
  final Todo todo;
  final ValueChanged<Todo> onTap;
  const TodoListItem({super.key, required this.todo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: todo.completed
          ? Icon(Icons.check_box_outlined)
          : Icon(Icons.check_box_outline_blank),
      title: Text(todo.description),
      subtitle: Text(todo.endDate.toIso8601String()),
      onTap: () => onTap(todo),
    );
  }
}
