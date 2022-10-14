import 'dart:io';

import '../databases/database.dart';
import '../providers/app_server_provider.dart';

class DataUploadProvider extends AppServerProvider {
  Future<bool> uploadFiles({
    required String claimNumber,
    required double latitude,
    required double longitude,
    required File file,
    bool isDoc = false,
  }) async {
    final int uploadId = await OMeetDatabase.instance.create(
      UploadObject(
        claimNo: claimNumber,
        latitude: latitude,
        longitude: longitude,
        file: file.path,
        time: DateTime.now(),
      ),
    );
    final Map<String, String> _data = <String, String>{
      'Claim_No': claimNumber,
      'lat': latitude.toString(),
      'long': longitude.toString(),
    };
    final Map<String, String> _files = <String, String>{
      'anyfile': file.path,
    };
    final DecodedResponse _requestResponse = await multiPartRequest(
      data: _data,
      files: _files,
    );
    if (_requestResponse.statusCode == successCode) {
      await OMeetDatabase.instance.delete(uploadId);
      return true;
    }
    return false;
  }
}
