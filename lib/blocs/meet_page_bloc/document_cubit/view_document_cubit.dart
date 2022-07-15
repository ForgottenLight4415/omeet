import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/repositories/meet_documents_repo.dart';

part 'view_document_state.dart';

enum DocType { image, pdf, video }

class ViewDocumentCubit extends Cubit<ViewDocumentState> {
  final MeetDocumentsRepository _repository = MeetDocumentsRepository();
  ViewDocumentCubit() : super(ViewDocumentInitial());

  Future<void> viewDocument(String documentUrl) async {
    emit(ViewDocumentLoading());
    try {
      final String type = documentUrl.split('.').last;
      final String doc = await _repository.getDocument(documentUrl);
      final DocType docType;

      if (type == 'jpg' || type == 'jpeg' || type == 'png') {
        docType = DocType.image;
      } else if (type == 'mp4') {
        docType = DocType.video;
      } else {
        docType = DocType.pdf;
      }

      emit(ViewDocumentReady(doc, docType));
    } on SocketException {
      emit(ViewDocumentFailed(1000, "Couldn't connect to server."));
    } on Exception catch (e) {
      emit(ViewDocumentFailed(2000, e.toString()));
    }
  }
}
