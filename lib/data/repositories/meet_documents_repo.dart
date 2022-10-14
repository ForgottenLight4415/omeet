import '../models/document.dart';
import '../providers/document_provider.dart';

class MeetDocumentsRepository {
  final DocumentProvider _provider = DocumentProvider();

  Future<List> getDocuments(String claimNumber, DocumentType type) =>
      _provider.getDocuments(claimNumber, type);

  Future<String> getDocument(String documentUrl) =>
      _provider.getDocument(documentUrl);
}
