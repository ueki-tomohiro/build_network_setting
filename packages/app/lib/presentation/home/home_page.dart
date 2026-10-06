import 'package:app/controller/todo_controller.dart';
import 'package:app/presentation/home/home.dart';
import 'package:app/routing/app_routing.dart';
import 'package:external_todo/api.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosState = ref.watch(todoListControllerProvider);
    final todos = useMemoized<List<Todo>>(() {
      if (todosState is! AsyncData) return [];
      return todosState.value ?? [];
    }, [todosState]);

    return Home(
      todos: todos,
      registerTodo: () {
        context.pushNamed(AppRoute.register.name);
      },
      selectTodo: (value) {
        context.pushNamed(
          AppRoute.detail.name,
          pathParameters: <String, String>{'todo_id': value.todoId.toString()},
        );
      },
    );
  }
}
