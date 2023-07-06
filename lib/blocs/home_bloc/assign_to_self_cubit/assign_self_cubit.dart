import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../data/providers/app_server_provider.dart';
import '../../../data/repositories/claim_repo.dart';
import '../../../utilities/check_connection.dart';

part 'assign_self_state.dart';

class AssignSelfCubit extends Cubit<AssignSelfState> {
  final ClaimRepository _homeRepository = ClaimRepository();
  AssignSelfCubit() : super(AssignSelfInitial());

  Future<void> assignToSelf(BuildContext context, Map<String, String> payload) async {
    if (!await checkConnection(context)) {
      emit(AssignSelfFailed(1000, "No internet connection"));
      return;
    }
    emit(AssignSelfLoading());
    try {
      emit(
        AssignSelfSuccess(
          await _homeRepository.assignToSelf(payload),
        ),
      );
    } on SocketException {
      emit(AssignSelfFailed(1000, "Failed to connect the server."));
    } on AppException catch (a) {
      emit(AssignSelfFailed(a.code, a.cause));
    } catch (e) {
      emit(AssignSelfFailed(2000, e.toString()));
    }
  }
}
