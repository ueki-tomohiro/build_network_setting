import 'package:app/repository/token_repository.dart';
import 'package:external_todo/api.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:riverpod/riverpod.dart';

abstract class ITodoRepository {
  Future<Todo?> registerTodo(String description, DateTime endDate);
  Future<Todo?> updateTodo(
    int todoId,
    String description,
    DateTime endDate,
    bool completed,
  );
  Future<void> deleteTodo(int todoId);
  Future<List<Todo>?> getTodos();
  Future<Todo?> getTodo(int todoId);
}

class TodoRepository implements ITodoRepository {
  final ITokenRepository tokenRepository;
  late TodoApi _todoApi;

  TodoRepository(this.tokenRepository) {
    final authentication = tokenRepository.createAuthentication();

    final apiClient = ApiClient(
      basePath: FlavorConfig.instance.variables['todo-api'] as String,
      authentication: authentication,
    );

    apiClient.addDefaultHeader(
      'x-app-version',
      FlavorConfig.instance.variables['app-version'] as String,
    );
    apiClient.addDefaultHeader(
      'x-app-name',
      FlavorConfig.instance.variables['app-name'] as String,
    );
    _todoApi = TodoApi(apiClient);
  }

  @override
  Future<List<Todo>?> getTodos() => _todoApi.getTodos();

  @override
  Future<Todo?> getTodo(int todoId) => _todoApi.getTodo(todoId);

  @override
  Future<Todo?> registerTodo(String description, DateTime endDate) =>
      _todoApi.registerTodo(
        TodoRegisterble(description: description, endDate: endDate),
      );

  @override
  Future<Todo?> updateTodo(
    int todoId,
    String description,
    DateTime endDate,
    bool completed,
  ) => _todoApi.updateTodo(
    todoId,
    TodoUpdatable(
      description: description,
      endDate: endDate,
      completed: completed,
    ),
  );

  @override
  Future<void> deleteTodo(int todoId) => _todoApi.deleteTodo(todoId);
}

final todoRepositoryProvider = Provider.autoDispose<ITodoRepository>((ref) {
  final tokenRepository = ref.read(tokenRepositoryProvider);
  return TodoRepository(tokenRepository);
});
