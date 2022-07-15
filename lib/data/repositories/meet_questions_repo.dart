import '../models/question.dart';
import '../providers/questions_provider.dart';

class MeetQuestionsRepository {
  final MeetQuestionsProvider _provider = MeetQuestionsProvider();
  List<Question> _questions = const <Question>[];

  Future<List<Question>> getQuestions(String claimNumber) => _provider.getQuestions(claimNumber);

  Future<bool> submitQuestions(String claimNumber, List<Question> questions) => _provider.submitQuestions(claimNumber, questions);

  List<Question> get questions => _questions;

  void setQuestions(List<Question> questions) {
    _questions = questions;
  }
}
