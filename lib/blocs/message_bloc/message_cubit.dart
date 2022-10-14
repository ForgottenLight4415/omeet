import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/providers/app_server_provider.dart';
import '../../data/repositories/call_repo.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final CallRepository _callRepo = CallRepository();

  MessageCubit() : super(MessageInitial());

  Future<void> messageClient({required String claimNumber, required String phoneNumber}) async {
    emit(SendingMessage());
    try {
      if (await _callRepo.sendMessage(claimNumber: claimNumber, phoneNumber: phoneNumber)) {
        emit(MessageSent());
      }
    } on SocketException {
      emit(SendingFailed(1000, "Couldn't connect to server"));
    } on AppException catch (e) {
      emit(SendingFailed(e.code, e.cause));
    }
  }
}
