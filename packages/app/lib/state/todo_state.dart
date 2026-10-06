import 'package:external_todo/api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_state.freezed.dart';

@freezed
sealed class TodoState with _$TodoState {
  factory TodoState.loaded({required Todo todo}) = TodoStateLoaded;

  factory TodoState.registered({required Todo todo}) = TodoStateRegistered;

  factory TodoState.updated({required Todo todo}) = TodoStateUpdated;

  factory TodoState.failure({Object? error, StackTrace? trace}) =
      TodoStateFailure;

  factory TodoState.deleted() = TodoStateDeleted;

  factory TodoState.undefined() = TodoStateUndefined;
}
