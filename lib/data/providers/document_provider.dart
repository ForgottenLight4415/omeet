import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:html/dom.dart' as dom;
import 'package:omeet_motor/utilities/api_urls.dart';
import 'package:omeet_motor/utilities/app_constants.dart';

import '../models/document.dart';
import '../providers/app_server_provider.dart';

class DocumentProvider extends AppServerProvider {

  Future<List> getDocuments(String caseId, DocumentType type) async {
    String urlPath;

    switch (type) {
      case DocumentType.file:
        urlPath = ApiUrl.getDocumentsUrl;
        break;
      case DocumentType.audio:
        urlPath = ApiUrl.getAudioUrl;
        break;
      case DocumentType.video:
        urlPath = ApiUrl.getVideosUrl;
        break;
      case DocumentType.image:
        urlPath = ApiUrl.getDocumentsUrl;
        break;
    }
    final DecodedResponse _response = await postRequest(
      path: urlPath,
      data: <String, String> {
        "CASE_ID": caseId,
      },
    );
    Map<String, dynamic> _rData = _response.data!;
    if (type == DocumentType.audio) {
      if (_rData["allpost"] != null) {
        final List<AudioRecording> _recordings = [];
        for (var document in _rData["allpost"]) {
          _recordings.add(AudioRecording.fromJson(document));
        }
        return _recordings;
      }
      throw const AppException(code: 204, cause: "No data");
    } else {
      if (_rData["allpost"] != null) {
        final List<Document> _documents = [];
        for (var document in _rData["allpost"]) {
          _documents.add(Document.fromJson(document, type));
        }
        return _documents;
      }
      throw const AppException(code: 204, cause: "No data");
    }
  }

  Future<String> getDocument(String documentUrl) async {
    final Response _response = await get(Uri.parse(documentUrl));
    final dom.Document htmlDocument = parse(_response.body);
    final List<dom.Element> obj = htmlDocument.getElementsByTagName('object');
    String? _link;
    for (var element in obj) {
      _link = element.attributes['data'] ?? AppStrings.blank;
    }
    return _link ?? AppStrings.blank;
  }
}
