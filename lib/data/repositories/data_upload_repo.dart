import 'dart:io';
import 'package:rc_clone/data/databases/database.dart';
import 'package:rc_clone/data/providers/data_upload_provider.dart';

class DataUploadRepository {
  final DataUploadProvider _provider = DataUploadProvider();

  Future<bool> uploadData({
    required String claimNumber,
    required double latitude,
    required double longitude,
    required File file,
    bool isImage = false,
  }) =>
      _provider.uploadFiles(
        claimNumber: claimNumber,
        latitude: latitude,
        longitude: longitude,
        file: file,
        isImage: isImage
      );

  Future<List<Map<String, Object?>>> getPendingUploads() async {
    return await OMeetDatabase.instance.show();
  }
}
