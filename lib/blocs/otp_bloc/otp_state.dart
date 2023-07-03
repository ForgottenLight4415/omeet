part of 'otp_cubit.dart';

@immutable
abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSuccess extends OtpState {}

class OtpVerificationFailureState extends OtpState {
  final int code;
  final String cause;

  OtpVerificationFailureState({required this.code, required this.cause});
}

class RequestingNewOtp extends OtpState {}

class RequestedNewOtp extends OtpState {}

class RequestOtpFailure extends OtpState {}
