import 'package:app/component/loading.dart';
import 'package:app/controller/todo_controller.dart';
import 'package:app/presentation/detail/detail.dart';
import 'package:app/routing/app_routing.dart';
import 'package:app/state/todo_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DetailPage extends HookConsumerWidget {
  final int todoId;
  const DetailPage({super.key, required this.todoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoState = ref.watch(todoControllerProvider(todoId));

    final todo = useMemoized(() {
      if (todoState is! AsyncData) return null;
      final value = todoState.value;
      if (value is! TodoStateLoaded) return null;
      return value.todo;
    }, [todoState]);

    return Builder(
      builder: (context) {
        if (todo != null) {
          return Detail(
            todo: todo,
            editTodo: () {
              context.pushNamed(
                AppRoute.edit.name,
                pathParameters: <String, String>{'todo_id': todoId.toString()},
              );
            },
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
