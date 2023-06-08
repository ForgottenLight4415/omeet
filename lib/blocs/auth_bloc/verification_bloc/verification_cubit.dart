import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/repositories/auth_repo.dart';
import '../../../data/providers/app_server_provider.dart';

part 'verification_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  final AuthRepository _authRepository = AuthRepository();
  VerificationCubit() : super(VerificationInitial());

  Future<void> verifyOtp(String email, String otp) async {
    emit(VerificationVerifying());
    try {
      if (await _authRepository.verifyOtp(email,otp)) {
        emit(VerificationSuccess());
      } else {
        emit(VerificationFailed(401, "Incorrect OTP"));
      }
    } on SocketException {
      emit(VerificationFailed(1000, "Failed to connect the server."));
    } on AppException catch (a) {
      emit(VerificationFailed(a.code, a.cause));
    } catch (e) {
      emit(VerificationFailed(2000, e.toString()));
    }
  }
}
