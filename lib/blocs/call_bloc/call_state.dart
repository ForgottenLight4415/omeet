part of 'call_cubit.dart';

@immutable
abstract class CallState {}

class CallInitial extends CallState {}

class CallLoading extends CallState {}

class CallReady extends CallState {
  final String caseId;
  final String managerPhoneNumber;
  final String customerPhoneNumber;

  CallReady(this.caseId, this.managerPhoneNumber, this.customerPhoneNumber);
}

class CallFailed extends CallState {
  final int code;
  final String cause;

  CallFailed(this.code, this.cause);
}
