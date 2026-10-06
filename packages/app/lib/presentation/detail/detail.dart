import 'package:external_todo/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Detail extends HookWidget {
  final Todo todo;
  final VoidCallback editTodo;
  const Detail({super.key, required this.todo, required this.editTodo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: editTodo),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(todo.description, style: TextStyle(fontSize: 24)),
              ListTile(
                leading: todo.completed
                    ? Icon(Icons.check_box_outlined)
                    : Icon(Icons.check_box_outline_blank),
                title: Text(todo.completed ? '完了済み' : '未完了'),
              ),
              Text(
                todo.endDate.toIso8601String(),
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
