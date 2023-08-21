part of 'modify_question_bloc.dart';

class ModifyQuestionState {
  final Question question;

  ModifyQuestionState({required this.question});

  ModifyQuestionState copyWith({Question? question}) => ModifyQuestionState(
        question: question ?? this.question,
      );
}
