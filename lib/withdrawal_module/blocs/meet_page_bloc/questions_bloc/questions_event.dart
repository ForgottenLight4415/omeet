part of 'questions_bloc.dart';

@immutable
abstract class QuestionsEvent {}

class GetQuestionsEvent extends QuestionsEvent {
  final String claimNumber;

  GetQuestionsEvent({required this.claimNumber});
}

class AddQuestionEvent extends QuestionsEvent {
  final String? question;

  AddQuestionEvent({required this.question});
}
