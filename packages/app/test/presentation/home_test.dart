import 'package:app/presentation/home/home.dart';
import 'package:external_todo/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final todos = [
    Todo(
      todoId: 1,
      description: 'buy milk',
      endDate: DateTime(2026, 10, 6),
      completed: false,
    ),
    Todo(
      todoId: 2,
      description: 'write report',
      endDate: DateTime(2026, 10, 7),
      completed: true,
    ),
  ];

  testWidgets('shows todos and notifies the selected todo', (tester) async {
    Todo? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Home(
          todos: todos,
          registerTodo: () {},
          selectTodo: (todo) => selected = todo,
        ),
      ),
    );

    expect(find.text('buy milk'), findsOneWidget);
    expect(find.text('write report'), findsOneWidget);
    expect(find.byIcon(Icons.check_box_outline_blank), findsOneWidget);
    expect(find.byIcon(Icons.check_box_outlined), findsOneWidget);

    await tester.tap(find.text('write report'));

    expect(selected, todos[1]);
  });

  testWidgets('notifies register when the add button is tapped', (
    tester,
  ) async {
    var registered = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Home(
          todos: const [],
          registerTodo: () => registered = true,
          selectTodo: (_) {},
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.add_box));

    expect(registered, isTrue);
  });
}
