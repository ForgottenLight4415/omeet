part of 'otp_cubit.dart';

@immutable
abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSuccess extends OtpState {}

class OtpFailed extends OtpState {
  final int code;
  final String cause;

  OtpFailed(this.code, this.cause);
}
