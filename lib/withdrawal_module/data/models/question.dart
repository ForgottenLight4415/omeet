import 'dart:convert';

class Question {
  final int id;
  final String _resetQuestion;
  final String _category;

  String question;
  bool flag;
  String? _answer;

  Question.fromJson(Map<String, dynamic> decodedJson)
      : id = int.parse(decodedJson["id"]),
        question = decodedJson["question"],
        _resetQuestion = decodedJson["question"],
        _category = decodedJson["category"],
        flag = int.parse(decodedJson["status"]) == 1;

  String toJson() {
    Map<String, dynamic> _question = <String, dynamic>{
      'id': id,
      'question': question,
      'answer': _answer ?? "Unanswered",
      'flag': flag ? 1 : 0,
      'category': _category
    };
    return jsonEncode(_question);
  }

  void setAnswer(String? answer) {
    _answer = answer;
  }

  String? getAnswer() {
    return _answer;
  }

  void toggleFlag() {
    flag = !flag;
  }

  void setQuestion(String? question) {
    if (question != null) {
      this.question = question;
    }
  }

  void resetQuestion() {
    question = _resetQuestion;
  }
}
