part of 'questions_bloc.dart';

@immutable
abstract class QuestionsState {}

class QuestionsInitial extends QuestionsState {}

class QuestionsReady extends QuestionsState {
  final List<Question> questions;
  final bool isModified;

  QuestionsReady({required this.questions, this.isModified = false});
}

class QuestionsLoading extends QuestionsState {}

class QuestionsLoadingFailed extends QuestionsState {
  final int code;
  final String cause;

  QuestionsLoadingFailed({required this.code, required this.cause});
}

class QuestionsEmpty extends QuestionsState {}
