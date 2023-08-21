import '../../utilities/api_urls.dart';

class DocumentPageArguments {
  final String claimNumber;
  final bool readOnly;

  const DocumentPageArguments(this.claimNumber, this.readOnly);
}

enum DocumentType { file, audio, video, image }

// This class is for PDF,Image and video documents
class Document {
  final int id;
  final String claimNumber;
  final String fileUrl;
  final String fileName;
  final String fileType;
  final String fileDesc;
  final DocumentType type;
  final String uploadDateTime;

  Document.fromJson(Map<String, dynamic> decodedJson, this.type)
      : id = int.parse(decodedJson["id"]),
        claimNumber = decodedJson['CASE_ID'] ?? "Unavailable",
        fileUrl = _getDocumentUrl(decodedJson, type),
        fileName = _getDocumentName(decodedJson, type),
        fileType = decodedJson["document_type"] == null ||  decodedJson["document_type"] == ""
            ? "Unavailable"
            : decodedJson["document_type"],
        fileDesc = decodedJson["document_description"] == null ||  decodedJson["document_description"] == ""
            ? "Unavailable"
            : decodedJson["document_description"],
        uploadDateTime = _getDocumentDateTime(decodedJson, type);

  static String _getDocumentUrl(Map<String, dynamic> decodedJson, DocumentType type) {
      switch (type) {
        case DocumentType.file:
        case DocumentType.image:
          return ApiUrl.actualDocBaseUrl + Uri.encodeComponent(decodedJson["targetfolder"]).replaceAll(' ', '%20');
        case DocumentType.video:
          return ApiUrl.actualVideoBaseUrl + decodedJson["videourl"].replaceAll(' ', '%20');
        case DocumentType.audio:
          return decodedJson['callRecordingLocation'];
      }
  }

  static String _getDocumentName(Map<String, dynamic> decodedJson, DocumentType type) {
    switch (type) {
      case DocumentType.file:
      case DocumentType.image:
        return decodedJson["targetfolder"];
      case DocumentType.video:
        return decodedJson["videourl"];
      case DocumentType.audio:
        return decodedJson['callRecordingLocation'].split("/").last;
    }
  }

  static String _getDocumentDateTime(Map<String, dynamic> decodedJson, DocumentType type) {
    if (type == DocumentType.audio) {
      return decodedJson["callDateTime"];
    } else if (decodedJson['uploaddatetime'] != null) {
      return decodedJson['uploaddatetime'];
    } else {
      return decodedJson['updateddate'] + " " + decodedJson['updatedtime'];
    }
  }
}

class AudioRecording extends Document {
  final String callFrom;
  final String callTo;
  final String callUrl;

  AudioRecording.fromJson(Map<String, dynamic> decodedJson)
      : callFrom = decodedJson['callFrom'],
        callTo = decodedJson['callTo'],
        callUrl = decodedJson['callRecordingLocation'],
        super.fromJson(decodedJson, DocumentType.audio);
}

