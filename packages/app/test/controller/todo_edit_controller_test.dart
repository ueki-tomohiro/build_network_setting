import 'package:app/controller/todo_edit_controller.dart';
import 'package:app/repository/todo_repository.dart';
import 'package:app/state/todo_state.dart';
import 'package:external_todo/api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../mocks.dart';

void main() {
  late MockITodoRepository repository;
  late ProviderContainer container;

  final endDate = DateTime(2026, 10, 6);
  final todo = Todo(
    todoId: 1,
    description: 'buy milk',
    endDate: endDate,
    completed: false,
  );

  setUp(() {
    repository = MockITodoRepository();
    container = ProviderContainer.test(
      overrides: [todoRepositoryProvider.overrideWithValue(repository)],
    );
  });

  Future<ProviderSubscription<AsyncValue<TodoState>>> listen(
    int? todoId,
  ) async {
    final sub = container.listen(todoEditControllerProvider(todoId), (_, _) {});
    await container.read(todoEditControllerProvider(todoId).future);
    return sub;
  }

  test('initial state is undefined', () async {
    final sub = await listen(null);

    expect(sub.read().value, TodoState.undefined());
  });

  test('registerTodo updates state with the registered todo', () async {
    when(repository.registerTodo('buy milk', endDate))
        .thenAnswer((_) async => todo);
    final sub = await listen(null);

    await container
        .read(todoEditControllerProvider(null).notifier)
        .registerTodo('buy milk', endDate);

    expect(sub.read().value, TodoState.updated(todo: todo));
  });

  test('registerTodo sets failure state when the response is null', () async {
    when(repository.registerTodo('buy milk', endDate))
        .thenAnswer((_) async => null);
    final sub = await listen(null);

    await container
        .read(todoEditControllerProvider(null).notifier)
        .registerTodo('buy milk', endDate);

    expect(sub.read().value, isA<TodoStateFailure>());
  });

  test('updateTodo updates state with the updated todo', () async {
    when(repository.updateTodo(1, 'buy milk', endDate, true))
        .thenAnswer((_) async => todo);
    final sub = await listen(1);

    await container
        .read(todoEditControllerProvider(1).notifier)
        .updateTodo('buy milk', endDate, true);

    verify(repository.updateTodo(1, 'buy milk', endDate, true)).called(1);
    expect(sub.read().value, TodoState.updated(todo: todo));
  });

  test('updateTodo does nothing without todoId', () async {
    final sub = await listen(null);

    await container
        .read(todoEditControllerProvider(null).notifier)
        .updateTodo('buy milk', endDate, true);

    verifyZeroInteractions(repository);
    expect(sub.read().value, TodoState.undefined());
  });

  test('deleteTodo sets deleted state', () async {
    final sub = await listen(1);

    await container.read(todoEditControllerProvider(1).notifier).deleteTodo();

    verify(repository.deleteTodo(1)).called(1);
    expect(sub.read().value, TodoState.deleted());
  });

  test('sets error state when the request fails', () async {
    when(repository.deleteTodo(1)).thenThrow(Exception('network error'));
    final sub = await listen(1);

    await container.read(todoEditControllerProvider(1).notifier).deleteTodo();

    expect(sub.read().hasError, isTrue);
  });
}
