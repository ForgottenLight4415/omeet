import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/question.dart';
import '../../../data/providers/app_server_provider.dart';
import '../../../data/repositories/meet_questions_repo.dart';

part 'questions_event.dart';
part 'questions_state.dart';

class QuestionsBloc extends Bloc<QuestionsEvent, QuestionsState> {
  final MeetQuestionsRepository _repository = MeetQuestionsRepository();

  QuestionsBloc() : super(QuestionsInitial()) {
    on<GetQuestionsEvent>(_onGetQuestionsEvent);
    on<AddQuestionEvent>(_addQuestionEvent);
  }

  Future<void> _onGetQuestionsEvent(
    GetQuestionsEvent event,
    Emitter<QuestionsState> emit,
  ) async {
    emit(QuestionsLoading());
    try {
      final List<Question> _questions = await _repository.getQuestions(event.claimNumber);
      _repository.setQuestions(_questions);
      emit(QuestionsReady(questions: _questions));
    } on AppException catch (a) {
      emit(QuestionsLoadingFailed(code: a.code, cause: a.cause));
    } on SocketException {
      emit(QuestionsLoadingFailed(code: 1000, cause: "Couldn't connect to server."));
    } catch (_) {
      emit(QuestionsLoadingFailed(code: 2000, cause: "Something went wrong."));
    }
  }

  Future<void> _addQuestionEvent(
    AddQuestionEvent event,
    Emitter<QuestionsState> emit,
  ) async {
    if (event.question == null || event.question!.isEmpty) {
      return;
    }
    final _savedQuestions = _repository.questions;
    final Map<String, dynamic> _rawQuestion = <String, dynamic>{
      "id": _savedQuestions.length.toString(),
      "question": event.question,
      "category": "OWN_QUESTION",
      "status": "0"
    };
    final Question _question = Question.fromJson(_rawQuestion);
    _savedQuestions.add(_question);
    _repository.setQuestions(_savedQuestions);
    emit(QuestionsReady(questions: _savedQuestions, isModified: true));
  }
}
