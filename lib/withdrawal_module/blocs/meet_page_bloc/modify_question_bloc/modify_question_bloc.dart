import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/question.dart';

part 'modify_question_event.dart';
part 'modify_question_state.dart';

class ModifyQuestionBloc extends Bloc<ModifyQuestionEvent, ModifyQuestionState> {
  final Question question;

  ModifyQuestionBloc({required this.question}) : super(ModifyQuestionState(question: question)) {
    on<ModifyQuestion>(_modifyQuestion);
    on<ToggleFlag>(_toggleFlag);
    on<AnswerQuestion>(_answerQuestion);
    on<ResetQuestion>(_resetQuestion);
  }

  Future<void> _modifyQuestion(
    ModifyQuestion event,
    Emitter<ModifyQuestionState> emit,
  ) async {
    if (event.question == null || event.question!.isEmpty) {
      return;
    }
    state.question.setQuestion(event.question);
    emit(state.copyWith(question: state.question));
  }

  Future<void> _toggleFlag(
    ToggleFlag event,
    Emitter<ModifyQuestionState> emit,
  ) async {
    state.question.toggleFlag();
    emit(state.copyWith(question: state.question));
  }

  Future<void> _answerQuestion(
    AnswerQuestion event,
    Emitter<ModifyQuestionState> emit,
  ) async {
    if (event.answer == null || event.answer!.isEmpty) {
      return;
    }
    state.question.setAnswer(event.answer);
    emit(state.copyWith(question: state.question));
  }

  Future<void> _resetQuestion(
    ResetQuestion event,
    Emitter<ModifyQuestionState> emit,
  ) async {
    state.question.resetQuestion();
    emit(state.copyWith(question: state.question));
  }
}
