import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:omeet_motor/utilities/show_snackbars.dart';

import '../../utilities/api_urls.dart';
import '../../utilities/app_constants.dart';

class DecodedResponse {
  final int statusCode;
  final String? reasonPhrase;
  final Map<String, dynamic>? data;

  const DecodedResponse({
    required this.statusCode,
    this.reasonPhrase = AppStrings.unavailable,
    this.data,
  });
}

class AppServerProvider {
  final int appError = 700;
  final int successCode = 200;
  final int notFound = 404;
  final int error = 500;

  DecodedResponse processResponse(Response response) {
    return DecodedResponse(
      statusCode: response.statusCode,
      reasonPhrase: response.reasonPhrase ?? AppStrings.unknown,
      data: jsonDecode(response.body),
    );
  }

  Future<DecodedResponse> getRequest({
    String? baseUrl,
    String? path,
    Map<String, dynamic>? data,
  }) async {
    try {
      Uri uri = Uri.parse((baseUrl ?? ApiUrl.baseUrl) + (path ?? ""));
      if (data != null) {
        uri = uri.replace(queryParameters: data);
      }
      final Response _response = await get(
        uri,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json",
        },
      );
      return processResponse(_response);
    } catch (e) {

      throw AppException(
        code: appError,
        cause: e.toString(),
      );
    }
  }

  Future<DecodedResponse> postRequest({
    String? baseUrl,
    String? path,
    required Map<String, dynamic> data,
    Map<String, String>? headers,
  }) async {
    try {
      final Response _response = await post(
        Uri.parse((baseUrl ?? ApiUrl.baseUrl) + (path ?? "")),
        headers: headers ??
            <String, String>{
              "Content-Type": "application/json; charset=UTF-8",
              "Accept": "application/json",
            },
        body: jsonEncode(data),
      );
      return processResponse(_response);
    } catch (e) {
      throw AppException(
        code: appError,
        cause: e.toString(),
      );
    }
  }

  Future<DecodedResponse> multiPartRequest({
    String? baseUrl,
    String? path,
    required Map<String, String> data,
    required Map<String, String> files,
    Map<String, String>? headers,
  }) async {
    final MultipartRequest _request = MultipartRequest(
      "POST",
      Uri.parse((baseUrl ?? ApiUrl.baseUrl) + (path ?? "")),
    );
    _request.headers.addAll(<String, String>{
      "Content-Type": "multipart/form-data",
    });
    if (headers != null) {
      _request.headers.addAll(headers);
    }
    _request.fields.addAll(data);
    files.forEach((key, value) async {
      _request.files.add(await MultipartFile.fromPath(key, value));
    });
    Response _multipartResponse = await Response.fromStream(
      await _request.send(),
    );
    return DecodedResponse(
      statusCode: _multipartResponse.statusCode,
      reasonPhrase: _multipartResponse.reasonPhrase,
    );
  }
}

class AppException implements Exception {
  final int code;
  final String cause;

  const AppException({required this.code, required this.cause});

  void displayExceptionSnackBar(BuildContext context) {
    showInfoSnackBar(context, cause, color: Colors.red);
  }
}
