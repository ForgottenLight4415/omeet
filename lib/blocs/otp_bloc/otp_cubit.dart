import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/providers/app_server_provider.dart';
import '../../data/repositories/auth_repo.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final AuthRepository _authRepository = AuthRepository();
  OtpCubit() : super(OtpInitial());

  Future<void> verifyOtp(String email, String otp) async {
    emit(OtpLoading());
    try {
      if (await _authRepository.verifyOtp(email,otp)) {
        emit(OtpSuccess());
      } else {
        emit(OtpFailed(401, "Incorrect OTP"));
      }
    } on SocketException {
      emit(OtpFailed(1000, "Failed to connect the server."));
    } on AppException catch (a) {
      emit(OtpFailed(a.code, a.cause));
    } catch (e) {
      emit(OtpFailed(2000, e.toString()));
    }
  }
}
