import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/providers/app_server_provider.dart';
import '../../data/repositories/call_repo.dart';

part 'call_state.dart';

class CallCubit extends Cubit<CallState> {
  CallCubit() : super(CallInitial());

  void callClient(
      {required String claimNumber,
      required String phoneNumber,
      String? managerNumber}) async {
    emit(CallLoading());
    final CallRepository _callRepo = CallRepository();
    try {
      bool _callServiceResponse = await _callRepo.callClient(
        claimNumber: claimNumber,
        phoneNumber: phoneNumber,
        managerNumber: managerNumber,
      );
      if (_callServiceResponse) {
        emit(CallReady());
      }
    } on SocketException {
      emit(CallFailed(1000, "Couldn't connect to server"));
    } on AppException catch (e) {
      emit(CallFailed(e.code, e.cause));
    }
  }
}
