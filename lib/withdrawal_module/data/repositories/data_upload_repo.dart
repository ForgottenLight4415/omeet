import 'dart:io';

import '../../utilities/document_utilities.dart';
import '../databases/database.dart';
import '../providers/data_upload_provider.dart';

class DataUploadRepository {
  final DataUploadProvider _provider = DataUploadProvider();

  Future<bool> uploadData({
    required String claimId,
    required double latitude,
    required double longitude,
    required File file,
    bool uploadNow = false,
    bool directUpload = false,
    Map<String, Object?>? extraParams,
  }) =>
      _provider.uploadFiles(
        claimNumber: claimId,
        latitude: latitude,
        longitude: longitude,
        file: file,
        type: DocumentUtilities.getDocumentType(file.path),
        uploadNow: uploadNow,
        directUpload: directUpload,
        extraParams: extraParams,
      );

  Future<List<Map<String, Object?>>> getPendingUploads() async {
    return await OMeetDatabase.instance.show();
  }
}
