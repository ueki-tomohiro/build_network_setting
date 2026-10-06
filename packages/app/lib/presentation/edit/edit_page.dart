import 'package:app/component/loading.dart';
import 'package:app/controller/todo_controller.dart';
import 'package:app/controller/todo_edit_controller.dart';
import 'package:app/presentation/edit/edit.dart';
import 'package:app/state/todo_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditPage extends HookConsumerWidget {
  final int todoId;
  const EditPage({super.key, required this.todoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoState = ref.watch(todoControllerProvider(todoId));
    final editState = ref.watch(todoEditControllerProvider(todoId));

    final todo = useMemoized(() {
      if (todoState is! AsyncData) return null;
      final value = todoState.value;
      if (value is! TodoStateLoaded) return null;
      return value.todo;
    }, [todoState]);

    useEffect(() {
      if (editState.value is TodoStateUpdated) {
        Future.microtask(() {
          ref.invalidate(todoListControllerProvider);
          ref.invalidate(todoControllerProvider(todoId));
          context.pop();
        });
      }
      return null;
    }, [editState]);

    return Builder(
      builder: (context) {
        if (todo != null) {
          return Edit(
            todo: todo,
            updateTodo: (description, endDate, completed) {
              ref
                  .read(todoEditControllerProvider(todoId).notifier)
                  .updateTodo(description, endDate, completed);
            },
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
