import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/providers/app_server_provider.dart';
import '../../../data/repositories/meet_documents_repo.dart';
import '../../../data/models/document.dart';

part 'get_document_state.dart';

class GetDocumentCubit extends Cubit<GetDocumentState> {
  GetDocumentCubit() : super(GetDocumentInitial());

  final MeetDocumentsRepository _repository = MeetDocumentsRepository();

  void getDocuments(String claimNumber) async {
    emit(GetDocumentLoading());
    try {
      emit(GetDocumentReady(await _repository.getDocumentList(claimNumber)));
    } on ServerException catch (a) {
      emit(GetDocumentFailed(a.code, a.cause));
    } catch (b) {
      log(b.toString());
      emit(GetDocumentFailed(1000, "Something went wrong"));
    }
  }
}
