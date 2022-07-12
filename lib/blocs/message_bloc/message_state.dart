part of 'message_cubit.dart';

@immutable
abstract class MessageState {}

class MessageInitial extends MessageState {}

class SendingMessage extends MessageState {}

class MessageSent extends MessageState {}

class SendingFailed extends MessageState {
  final int code;
  final String cause;

  SendingFailed(this.code, this.cause);
}
