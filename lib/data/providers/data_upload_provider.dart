import 'dart:developer';
import 'dart:io';

import 'package:omeet_motor/data/repositories/auth_repo.dart';
import 'package:omeet_motor/utilities/api_urls.dart';

import '../../utilities/document_utilities.dart';
import '../databases/database.dart';
import '../models/document.dart';
import '../providers/app_server_provider.dart';

class DataUploadProvider extends AppServerProvider {
  Future<bool> uploadFiles({
    required String claimNumber,
    required double latitude,
    required double longitude,
    required File file,
    required bool directUpload,
    required DocumentType type,
    Map<String, Object?>? extraParams,
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
          directUpload: directUpload,
          time: DateTime.now(),
          extraParams: extraParams,
        ),
      );
    }

    if (uploadNow) {
      final Map<String, String> _data = <String, String>{
        'CASE_ID': claimNumber,
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'phone_no': await AuthRepository.getPhone(),
      };
      if (extraParams != null) {
        for (var element in extraParams.keys) {
          _data[element] = extraParams[element] as String;
        }
      }
      final Map<String, String> _files = <String, String>{
        'anyfile': file.path,
      };
      try {
        final DecodedResponse requestResponse = await multiPartRequest(
            baseUrl: ApiUrl.secondaryBaseUrl,
            data: _data,
            files: _files,
            path: DocumentUtilities.getUploadUrl(type)
        );
        if (requestResponse.statusCode == successCode) {
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
