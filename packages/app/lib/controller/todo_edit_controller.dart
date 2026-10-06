import 'dart:async';

import 'package:app/repository/todo_repository.dart';
import 'package:app/state/todo_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_edit_controller.g.dart';

@riverpod
class TodoEditController extends _$TodoEditController {
  @override
  FutureOr<TodoState> build(int? todoId) {
    return TodoState.undefined();
  }

  Future<void> registerTodo(String description, DateTime endDate) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard<TodoState>(() async {
      final ITodoRepository repository = ref.read(todoRepositoryProvider);
      final todo = await repository.registerTodo(description, endDate);
      if (todo != null) {
        return TodoState.updated(todo: todo);
      } else {
        return TodoState.failure();
      }
    });
  }

  Future<void> updateTodo(
    String description,
    DateTime endDate,
    bool completed,
  ) async {
    final todoId = this.todoId;
    if (todoId == null) return;

    state = const AsyncLoading();

    state = await AsyncValue.guard<TodoState>(() async {
      final ITodoRepository repository = ref.read(todoRepositoryProvider);
      final todo = await repository.updateTodo(
        todoId,
        description,
        endDate,
        completed,
      );
      if (todo != null) {
        return TodoState.updated(todo: todo);
      } else {
        return TodoState.failure();
      }
    });
  }

  Future<void> deleteTodo() async {
    final todoId = this.todoId;
    if (todoId == null) return;

    state = const AsyncLoading();

    state = await AsyncValue.guard<TodoState>(() async {
      final ITodoRepository repository = ref.read(todoRepositoryProvider);
      await repository.deleteTodo(todoId);
      return TodoState.deleted();
    });
  }

  Future<void> getTodo() async {
    final todoId = this.todoId;
    if (todoId == null) return;

    state = const AsyncLoading();

    state = await AsyncValue.guard<TodoState>(() async {
      final ITodoRepository repository = ref.read(todoRepositoryProvider);
      final todo = await repository.getTodo(todoId);
      if (todo != null) {
        return TodoState.loaded(todo: todo);
      } else {
        return TodoState.failure();
      }
    });
  }
}
