import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/providers/app_server_provider.dart';
import '../../data/repositories/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository = AuthRepository();
  AuthCubit() : super(AuthInitial());

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      if (await _authRepository.signIn(email: email, password: password)) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailed(401, "Incorrect email or password"));
      }
    } on SocketException {
      emit(AuthFailed(1000, "Failed to connect the server."));
    } on AppException catch (a) {
      emit(AuthFailed(a.code, a.cause));
    } catch (e) {
      emit(AuthFailed(2000, e.toString()));
    }
  }
}
