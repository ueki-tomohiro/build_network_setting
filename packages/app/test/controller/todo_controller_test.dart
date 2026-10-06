import 'package:app/controller/todo_controller.dart';
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

  final todo = Todo(
    todoId: 1,
    description: 'buy milk',
    endDate: DateTime(2026, 10, 6),
    completed: false,
  );

  setUp(() {
    repository = MockITodoRepository();
    container = ProviderContainer.test(
      overrides: [todoRepositoryProvider.overrideWithValue(repository)],
    );
  });

  group('todoControllerProvider', () {
    test('returns loaded state when the todo exists', () async {
      when(repository.getTodo(1)).thenAnswer((_) async => todo);

      final sub = container.listen(todoControllerProvider(1).future, (_, _) {});

      expect(await sub.read(), TodoState.loaded(todo: todo));
    });

    test('returns failure state when the todo does not exist', () async {
      when(repository.getTodo(1)).thenAnswer((_) async => null);

      final sub = container.listen(todoControllerProvider(1).future, (_, _) {});

      expect(await sub.read(), isA<TodoStateFailure>());
    });

    test(
      'returns failure state with the error when the request fails',
      () async {
        final error = Exception('network error');
        when(repository.getTodo(1)).thenThrow(error);

        final sub = container.listen(
          todoControllerProvider(1).future,
          (_, _) {},
        );
        final state = await sub.read();

        expect(state, isA<TodoStateFailure>());
        expect((state as TodoStateFailure).error, error);
      },
    );
  });

  group('todoListControllerProvider', () {
    test('returns todos', () async {
      when(repository.getTodos()).thenAnswer((_) async => [todo]);

      final sub = container.listen(
        todoListControllerProvider.future,
        (_, _) {},
      );

      expect(await sub.read(), [todo]);
    });

    test('returns an empty list when the response is null', () async {
      when(repository.getTodos()).thenAnswer((_) async => null);

      final sub = container.listen(
        todoListControllerProvider.future,
        (_, _) {},
      );

      expect(await sub.read(), isEmpty);
    });
  });
}
