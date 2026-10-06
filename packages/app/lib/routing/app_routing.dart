import 'package:app/presentation/detail/detail_page.dart';
import 'package:app/presentation/edit/edit_page.dart';
import 'package:app/presentation/home/home_page.dart';
import 'package:app/presentation/register/register_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

enum AppRoute { home, register, detail, edit }

final routerProvider = Provider(
  (ref) => GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    debugLogDiagnostics: false,
    observers: [BotToastNavigatorObserver()],
    errorBuilder: (context, state) => throw ArgumentError('Invalid State'),
    routes: [
      GoRoute(
        path: '/home',
        name: AppRoute.home.name,
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'register',
            name: AppRoute.register.name,
            builder: (context, state) => const RegisterPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/todo/:todo_id',
        name: AppRoute.detail.name,
        builder: (context, state) =>
            DetailPage(todoId: state.getParamIntValue('todo_id')),
        routes: [
          GoRoute(
            path: 'edit',
            name: AppRoute.edit.name,
            builder: (context, state) =>
                EditPage(todoId: state.getParamIntValue('todo_id')),
          ),
        ],
      ),
    ],
  ),
);

extension GoRouterStateExtension on GoRouterState {
  String getParamValue(String name) {
    final value = pathParameters[name];
    if (value == null || value.isEmpty) {
      throw ArgumentError('Invalid $name');
    }
    return value;
  }

  int getParamIntValue(String name) {
    return int.parse(getParamValue(name));
  }
}
