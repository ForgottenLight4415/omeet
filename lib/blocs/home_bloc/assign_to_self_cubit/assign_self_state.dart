part of 'assign_self_cubit.dart';

@immutable
abstract class AssignSelfState {}

class AssignSelfInitial extends AssignSelfState {}

class AssignSelfLoading extends AssignSelfState {}

class AssignSelfSuccess extends AssignSelfState {
  final bool success;

  AssignSelfSuccess(this.success);
}

class AssignSelfFailed extends AssignSelfState {
  final int code;
  final String cause;

  AssignSelfFailed(this.code, this.cause);
}
