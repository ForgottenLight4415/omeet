import 'dart:io';

import 'package:http/http.dart';

import '../databases/database.dart';
import '../providers/app_server_provider.dart';
import '../../utilities/app_constants.dart';

class DataUploadProvider extends AppServerProvider {
  Future<bool> uploadFiles({
    required String claimNumber,
    required double latitude,
    required double longitude,
    required File file,
    bool isImage = false,
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
    final MultipartRequest _request = MultipartRequest(
      "POST",
      Uri.https(
        AppStrings.baseUrl,
        AppStrings.subDirectory + (isImage ? AppStrings.uploadImageUrl : AppStrings.uploadVideoUrl),
      ),
    );
    _request.headers.addAll({
      "Content-Type": "multipart/form-data",
    });
    _request.fields.addAll(<String, String>{
      'Claim_No': claimNumber,
      'lat': latitude.toString(),
      'long': longitude.toString(),
    });
    _request.files.add(await MultipartFile.fromPath('anyfile', file.path));
    Response _multipartResponse = await Response.fromStream(
      await _request.send(),
    );
    if (_multipartResponse.statusCode == successCode) {
      await OMeetDatabase.instance.delete(uploadId);
    }
    return _multipartResponse.statusCode == successCode;
  }
}
