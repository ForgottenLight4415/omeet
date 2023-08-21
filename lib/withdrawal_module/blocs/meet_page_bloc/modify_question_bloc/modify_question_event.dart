part of 'modify_question_bloc.dart';

@immutable
abstract class ModifyQuestionEvent {}

class ModifyQuestion extends ModifyQuestionEvent {
  final String? question;

  ModifyQuestion({required this.question});
}

class AnswerQuestion extends ModifyQuestionEvent {
  final String? answer;

  AnswerQuestion({required this.answer});
}

class ResetQuestion extends ModifyQuestionEvent {}

class ToggleFlag extends ModifyQuestionEvent {}
