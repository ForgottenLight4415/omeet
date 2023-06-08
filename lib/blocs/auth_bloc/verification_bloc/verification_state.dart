part of 'verification_cubit.dart';

@immutable
abstract class VerificationState {}

class VerificationInitial extends VerificationState {}

class VerificationVerifying extends VerificationState {}

class VerificationSuccess extends VerificationState {}

class VerificationFailed extends VerificationState {
  final int code;
  final String cause;

  VerificationFailed(this.code, this.cause);
}
