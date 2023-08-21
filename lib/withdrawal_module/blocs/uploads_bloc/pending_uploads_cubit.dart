import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../data/databases/database.dart';
import '../../data/providers/app_server_provider.dart';
import '../../data/repositories/data_upload_repo.dart';

part 'pending_uploads_state.dart';

class PendingUploadsCubit extends Cubit<PendingUploadsState> {
  final DataUploadRepository _repository = DataUploadRepository();

  PendingUploadsCubit() : super(PendingUploadsInitial());
  
  Future<void> getPendingUploads() async {
    emit(FetchingPendingUploads());
    try {
      List<Map<String, Object?>> uploads = await _repository.getPendingUploads();
      List<UploadObject> objects = [];
      for (var element in uploads) {
        objects.add(UploadObject.fromJson(element));
      }
      emit(FetchedPendingUploads(objects));
    } on AppException catch (a) {
      emit(FailedPendingUploads(a.code, a.cause));
    } on Exception catch (e) {
      log(e.toString());
      emit(FailedPendingUploads(1000, e.toString()));
    }
  }
}
