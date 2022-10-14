import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:html/dom.dart' as dom;
import 'package:omeet_motor/utilities/api_urls.dart';
import 'package:omeet_motor/utilities/app_constants.dart';

import '../models/document.dart';
import '../providers/app_server_provider.dart';

class DocumentProvider extends AppServerProvider {

  Future<List> getDocuments(String claimNumber, DocumentType type) async {
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
    final DecodedResponse _response = await getRequest(
      path: urlPath,
      data: <String, String> {
        (type == DocumentType.audio ? "Claim_No" : "cnum"): claimNumber,
      },
    );
    Map<String, dynamic> _rData = _response.data!;
    if (type != DocumentType.audio && _rData["allpost"] != null) {
      final List<Document> _documents = [];
      for (var document in _rData["allpost"]) {
        _documents.add(Document.fromJson(document, type));
      }
      return _documents;
    } else if (type == DocumentType.audio) {
      final List<AudioRecordings> _recordings = [];
      for (var document in _rData["allpost"]) {
        _recordings.add(AudioRecordings.fromJson(document));
      }
      return _recordings;
    } else {
      throw AppException(code: error, cause: "Unknown format");
    }
  }

  Future<List<Document>> getVideosList(String claimNumber) async {
    final Map<String, String> _data = <String, String>{
      "cnum": claimNumber,
    };
    final DecodedResponse _response = await getRequest(
      path: ApiUrl.getVideosUrl,
      data: _data,
    );
    Map<String, dynamic> _rData = _response.data!;
    List<Document> _documents = [];
    if (_rData["allpost"] != null) {
      for (var document in _rData["allpost"]) {
        _documents.add(Document.fromJson(document, DocumentType.file));
      }
    } else {
      throw const AppException(code: 500, cause: "Unknown format");
    }
    return _documents;
  }

  Future<List<Document>> getDocumentList(String claimNumber) async {
    final Map<String, String> _data = <String, String>{
      "Claim_No": claimNumber,
    };
    final DecodedResponse _response = await postRequest(
      path: ApiUrl.getDocumentsUrl,
      data: _data,
    );
    Map<String, dynamic> _rData = _response.data!;
    List<Document> _documents = [];
    if (_rData["allpost"] != null) {
      for (var document in _rData["allpost"]) {
        _documents.add(Document.fromJson(document, DocumentType.video));
      }
    }
    return _documents;
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
