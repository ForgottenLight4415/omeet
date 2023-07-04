import 'package:omeet_motor/utilities/api_urls.dart';

class DocumentPageArguments {
  final String claimNumber;
  final bool readOnly;

  const DocumentPageArguments(this.claimNumber, this.readOnly);
}

enum DocumentType { file, audio, video, image }

class Document {
  final int id;
  final String claimNumber;
  final String fileUrl;
  final DocumentType type;
  final String uploadDateTime;

  Document.fromJson(Map<String, dynamic> decodedJson, this.type)
      : id = int.parse(decodedJson["id"]),
        claimNumber = decodedJson['CASE_ID'] ?? decodedJson['CASE_ID'],
        fileUrl = decodedJson["targetfolder"] != null
            ? ApiUrl.actualDocBaseUrl + decodedJson["targetfolder"].replaceAll(' ', '%20')
            : ApiUrl.actualVideoBaseUrl + decodedJson["videourl"].replaceAll(' ', '%20'),
        uploadDateTime = decodedJson['uploaddatetime'] ?? decodedJson['updateddate'] + " " + decodedJson['updatedtime'];
}

class AudioRecordings {
  final int id;
  final String callFrom;
  final String callTo;
  final String callUrl;
  final String uploadDateTime;

  AudioRecordings.fromJson(Map<String, dynamic> decodedJson)
      : id = int.parse(decodedJson["id"]),
        callFrom = decodedJson['callFrom'],
        callTo = decodedJson['callTo'],
        uploadDateTime = decodedJson['callDateTime'],
        callUrl = decodedJson['callRecordingLocation'];
}

