import '../../utilities/api_urls.dart';

class DocumentPageArguments {
  final String claimNumber;
  final bool readOnly;

  const DocumentPageArguments(this.claimNumber, this.readOnly);
}

enum DocumentType { file, image }

class Document {
  final int id;
  final String claimNumber;
  final String fileUrl;
  final DocumentType type;
  final String uploadDateTime;

  Document.fromJson(Map<String, dynamic> decodedJson, this.type)
      : id = int.parse(decodedJson["id"]),
        claimNumber = decodedJson['claim_no'] ?? decodedJson['Claim_No'],
        fileUrl = ApiUrl.actualDocBaseUrl + decodedJson["targetfolder"].replaceAll(' ', '%20'),
        uploadDateTime = decodedJson['uploaddatetime'] ?? decodedJson['updateddate'] + decodedJson['updatedtime'];
}

