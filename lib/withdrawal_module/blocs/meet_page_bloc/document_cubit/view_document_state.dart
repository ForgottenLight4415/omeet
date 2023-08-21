part of 'view_document_cubit.dart';

@immutable
abstract class ViewDocumentState {}

class ViewDocumentInitial extends ViewDocumentState {}

class ViewDocumentLoading extends ViewDocumentState {}

class ViewDocumentReady extends ViewDocumentState {
  final String docUrl;
  final DocType docType;

  ViewDocumentReady(this.docUrl, this.docType);
}

class ViewDocumentFailed extends ViewDocumentState {
  final int code;
  final String cause;

  ViewDocumentFailed(this.code, this.cause);
}
