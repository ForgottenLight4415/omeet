import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/providers/app_server_provider.dart';
import '../../data/repositories/auth_repo.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final AuthRepository _authRepository = AuthRepository();
  OtpCubit() : super(OtpInitial());

  void verifyOtp(String phoneNumber, String otp, bool development) async {
    emit(OtpLoading());
    try {
      if (await _authRepository.verifyOtp(phoneNumber, otp, development: development)) {
        emit(OtpSuccess());
      } else {
        emit(OtpVerificationFailureState(code: 401, cause: "Incorrect OTP"));
      }
    } on SocketException {
      emit(
        OtpVerificationFailureState(
          code: 1000,
          cause: "Connection to OMeet servers has failed. Try again later.",
        ),
      );
    } on AppException catch (a) {
      emit(
        OtpVerificationFailureState(
          code: a.code,
          cause: a.cause,
        ),
      );
    } catch (e) {
      emit(
        OtpVerificationFailureState(
          code: 2000,
          cause: e.toString(),
        ),
      );
    }
  }

  void resendOtp(String phoneNumber, String password) async {
    emit(RequestingNewOtp());
    try {
      if (await _authRepository.resendOtp(phoneNumber, password)) {
        emit(RequestedNewOtp());
      } else {
        emit(RequestOtpFailure());
      }
    } catch (e) {
      emit(RequestOtpFailure());
    }
  }
}
