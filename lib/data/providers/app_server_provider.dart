import 'dart:convert';

import 'package:http/http.dart';

import '../../utilities/app_constants.dart';

class DecodedResponse {
  final int statusCode;
  final String? reasonPhrase;
  final Map<String, dynamic>? data;

  const DecodedResponse({required this.statusCode, this.reasonPhrase, this.data});
}

class AppServerProvider {
  final int successCode = 200;
  final int notFound = 404;
  final int error = 500;

  Future<DecodedResponse> postRequest(
      {required String path, required Map<String, dynamic> data}) async {
    final Response _response = await post(
      Uri.https(AppStrings.baseUrl, AppStrings.subDirectory + path),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
      },
      body: jsonEncode(data),
    );
    final DecodedResponse _decodedResponse = DecodedResponse(
      statusCode: _response.statusCode,
      reasonPhrase: _response.reasonPhrase,
      data: jsonDecode(_response.body),
    );
    return _decodedResponse;
  }

  Future<bool> callRequest(Map<String, dynamic> data) async {
    final Response _response = await post(
      Uri.https(
        AppStrings.bridgeCallBaseUrlNew,
        AppStrings.voiceCallUrlNew,
      ),
      headers: <String, String>{
        "Accept": "application/json",
        "Content-Type": "application/json; charset=UTF-8",
        "access-key": AppStrings.callTokenNew,
      },
      body: jsonEncode(data),
    );
    return _response.statusCode == successCode;
  }

  Future<bool> messageRequest(Map<String, dynamic> data) async {
    final Response _response = await get(
      Uri.http(
        AppStrings.sendMessageBaseUrl,
        AppStrings.sendMessageUrl,
        data,
      ),
    );
    return _response.statusCode == successCode;
  }
}

class ServerException implements Exception {
  final int code;
  final String cause;

  const ServerException({required this.code, required this.cause});
}
