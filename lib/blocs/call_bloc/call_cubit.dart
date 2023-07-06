import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/providers/app_server_provider.dart';
import '../../data/repositories/call_repo.dart';

part 'call_state.dart';

class CallCubit extends Cubit<CallState> {
  CallCubit() : super(CallInitial());

  void callClient(
      {required String? claimId,
      required String phoneNumber,
      String? managerNumber}) async {
    emit(CallLoading());
    final CallRepository _callRepo = CallRepository();
    try {
      final SharedPreferences _pref = await SharedPreferences.getInstance();
      bool _callServiceResponse = await _callRepo.callClient(
        managerNumber: managerNumber ?? _pref.getString("phone")!,
        phoneNumber: phoneNumber,
        claimNumber: claimId ?? "GODJN5432",
      );
      if (_callServiceResponse) {
        emit(CallReady(claimId!, managerNumber!, phoneNumber));
      }
    } on SocketException {
      emit(CallFailed(1000, "Couldn't connect to server"));
    } on AppException catch (e) {
      emit(CallFailed(e.code, e.cause));
    }
  }
}
