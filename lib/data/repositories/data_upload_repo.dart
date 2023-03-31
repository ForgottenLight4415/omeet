import 'dart:io';

import '../databases/database.dart';
import '../providers/data_upload_provider.dart';

class DataUploadRepository {
  final DataUploadProvider _provider = DataUploadProvider();

  Future<bool> uploadData({
    required String claimNumber,
    required double latitude,
    required double longitude,
    required File file,
    bool isDoc = false,
    bool uploadNow = false,
  }) =>
      _provider.uploadFiles(
        claimNumber: claimNumber,
        latitude: latitude,
        longitude: longitude,
        file: file,
        isDoc: isDoc,
        uploadNow: uploadNow
      );

  Future<List<Map<String, Object?>>> getPendingUploads() async {
    return await OMeetDatabase.instance.show();
  }
}
