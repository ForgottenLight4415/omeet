import 'dart:developer';
import 'dart:io';

import 'package:omeet_motor/utilities/api_urls.dart';

import '../databases/database.dart';
import '../providers/app_server_provider.dart';

class DataUploadProvider extends AppServerProvider {
  Future<bool> uploadFiles({
    required String claimNumber,
    required double latitude,
    required double longitude,
    required File file,
    bool isDoc = false,
    bool uploadNow = false,
  }) async {
    int uploadId = await OMeetDatabase.instance.exists(file.path);
    if (uploadId == 0) {
      uploadId = await OMeetDatabase.instance.create(
        UploadObject(
          claimNo: claimNumber,
          latitude: latitude,
          longitude: longitude,
          file: file.path,
          time: DateTime.now(),
        ),
      );
    }

    if (uploadNow) {
      final Map<String, String> _data = <String, String>{
        'CASE_ID': claimNumber,
        'lat': latitude.toString(),
        'long': longitude.toString(),
      };
      final Map<String, String> _files = <String, String>{
        'anyfile': file.path,
      };
      try {
        final DecodedResponse _requestResponse = await multiPartRequest(
            baseUrl: "https://omeet.in/MOTOR/",
            data: _data,
            files: _files,
            path: isDoc ? ApiUrl.uploadDocUrl : ApiUrl.uploadVideoUrl
        );
        log(_requestResponse.statusCode.toString());
        if (_requestResponse.statusCode == successCode) {
          await OMeetDatabase.instance.delete(uploadId);
          return true;
        }
      } catch (e) {
        log(e.toString());
      }
      return false;
    }
    return true;
  }
}
