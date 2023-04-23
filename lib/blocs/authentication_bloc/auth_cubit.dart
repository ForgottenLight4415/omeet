import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/providers/app_server_provider.dart';
import '../../data/repositories/auth_repo.dart';

part 'auth_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthRepository _authRepository = AuthRepository();
  AuthenticationCubit() : super(AuthenticationInitial());

  Future<void> signIn(String email, String password) async {
    emit(AuthenticationLoading());
    try {
      if (await _authRepository.signIn(email: email, password: password)) {
        emit(AuthenticationSuccess());
      } else {
        emit(AuthenticationFailed(401, "Incorrect email or password"));
      }
    } on SocketException {
      emit(AuthenticationFailed(1000, "Failed to connect the server."));
    } on AppException catch (a) {
      emit(AuthenticationFailed(a.code, a.cause));
    } catch (e) {
      emit(AuthenticationFailed(2000, e.toString()));
    }
  }
}
