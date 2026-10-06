import 'package:app/presentation/home/todo_list_item.dart';
import 'package:external_todo/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Home extends HookWidget {
  final List<Todo> todos;
  final VoidCallback registerTodo;
  final ValueChanged<Todo> selectTodo;
  const Home({
    super.key,
    required this.todos,
    required this.registerTodo,
    required this.selectTodo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(icon: const Icon(Icons.add_box), onPressed: registerTodo),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) =>
              TodoListItem(todo: todos[index], onTap: selectTodo),
        ),
      ),
    );
  }
}
