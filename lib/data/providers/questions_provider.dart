import 'package:omeet_motor/utilities/api_urls.dart';

import '../models/question.dart';
import 'app_server_provider.dart';

class MeetQuestionsProvider extends AppServerProvider {
  Future<List<Question>> getQuestions(String claimNumber) async {
    final Map<String, String> _data = <String, String>{
      "Claim_No": claimNumber,
    };
    final DecodedResponse _response = await postRequest(
      path: ApiUrl.getQuestionsUrl,
      data: _data,
    );
    Map<String, dynamic> _rData = _response.data!;
    List _rQuestions = _rData["allpost"] ?? [];
    List<Question> _modelQuestions = [];
    for (int i = 0; i < _rQuestions.length; i++) {
      _rQuestions[i]['id'] = i.toString();
      _modelQuestions.add(Question.fromJson(_rQuestions[i]));
    }
    return _modelQuestions;
  }

  Future<bool> submitQuestions(String claimNumber, List<Question> questions) async {
    List<String> _questions = [];
    for (var question in questions) {
      _questions.add(question.toJson());
    }
    final Map<String, dynamic> _data = <String, dynamic>{"claim": claimNumber, "qa": _questions};
    await postRequest(
      path: ApiUrl.submitAnswersUrl,
      data: _data,
    );
    return true;
  }
}
