import '../../utilities/app_constants.dart';
import '../models/question.dart';
import 'app_server_provider.dart';

class MeetQuestionsProvider extends AppServerProvider {
  Future<List<Question>> getQuestions(String claimNumber) async {
    final Map<String, String> _data = <String, String>{
      "Claim_No": claimNumber,
    };
    final DecodedResponse _response = await postRequest(
      path: AppStrings.getQuestionsUrl,
      data: _data,
    );
    if (_response.statusCode == successCode) {
      Map<String, dynamic> _rData = _response.data!;
      List _rQuestions = _rData["allpost"] ?? [];
      List<Question> _modelQuestions = [];
      for (int i = 0; i < _rQuestions.length; i++) {
        _rQuestions[i]['id'] = i.toString();
        _modelQuestions.add(Question.fromJson(_rQuestions[i]));
      }
      return _modelQuestions;
    } else {
      throw ServerException(
        code: _response.statusCode,
        cause: _response.reasonPhrase ?? AppStrings.unknown,
      );
    }
  }

  Future<bool> submitQuestions(String claimNumber, List<Question> questions) async {
    List<String> _questions = [];
    for (var question in questions) {
      _questions.add(question.toJson());
    }
    final Map<String, dynamic> _data = <String, dynamic>{"claim": claimNumber, "qa": _questions};
    final DecodedResponse _response = await postRequest(
      path: AppStrings.submitAnswersUrl,
      data: _data,
    );
    if (_response.statusCode == successCode) {
      return true;
    } else {
      throw ServerException(
        code: _response.statusCode,
        cause: _response.reasonPhrase ?? AppStrings.unknown,
      );
    }
  }
}
