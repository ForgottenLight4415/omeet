part of 'get_document_cubit.dart';

@immutable
abstract class GetDocumentState {}

class GetDocumentInitial extends GetDocumentState {}

class GetDocumentLoading extends GetDocumentState {}

class GetDocumentReady extends GetDocumentState {
  final List documents;

  GetDocumentReady(this.documents);
}

class GetDocumentFailed extends GetDocumentState {
  final int code;
  final String? cause;

  GetDocumentFailed(this.code, this.cause);
}
