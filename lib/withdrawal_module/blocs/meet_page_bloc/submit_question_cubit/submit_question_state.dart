part of 'submit_question_cubit.dart';

@immutable
abstract class SubmitQuestionState {}

class SubmitQuestionInitial extends SubmitQuestionState {}

class SubmitQuestionLoading extends SubmitQuestionState {}

class SubmitQuestionReady extends SubmitQuestionState {}

class SubmitQuestionFailed extends SubmitQuestionState {
  final int code;
  final String cause;

  SubmitQuestionFailed(this.code, this.cause);
}
