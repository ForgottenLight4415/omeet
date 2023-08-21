import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ed_screen_recorder/ed_screen_recorder.dart';
import 'package:location/location.dart';
import 'package:omeet_motor/utilities/location_service.dart';
import 'package:path_provider/path_provider.dart';

import '../../utilities/show_snackbars.dart';
import '../data/repositories/data_upload_repo.dart';
import 'app_constants.dart';

class ScreenRecorder {
  final EdScreenRecorder _edScreenRecorder = EdScreenRecorder();

  bool _isRecording = false;
  String? _claimNumber;

  LocationData? _locationData;

  Future<Map<String, dynamic>> startRecord({
    required BuildContext context,
    required String claimId,
  }) async {
    log("Starting screen record");
    if (_isRecording) {
      return <String, dynamic> {
        "code": "100",
        "message": "Recording in progress",
      };
    }
    LocationService locationService = LocationService();
    _locationData = await locationService.getLocation(context);

    String fileName = "${claimId}_${DateTime.now().microsecondsSinceEpoch}".replaceAll('/', '_');
    Directory? directory = await getExternalStorageDirectory();
    Directory _saveDirectory = await Directory(
      "${directory!.path}/ScreenRecordings",
    ).create(recursive: true);

    final Map<String, dynamic> response =
    await _edScreenRecorder.startRecordScreen(
      fileName: fileName,
      dirPathToSave: _saveDirectory.path,
      audioEnable: true,
    );
    _claimNumber = claimId;
    _isRecording = true;
    return response;
  }

  Future<Map<String, dynamic>> stopRecord(
      {required String claimId, required BuildContext context}) async {
    Map<String, dynamic> response = await _edScreenRecorder.stopRecord();
    File videoFile = response['file'];

    final DataUploadRepository _repository = DataUploadRepository();
    try {
      bool result = await _repository.uploadData(
        claimId: claimId,
        latitude: _locationData?.latitude ?? 0,
        longitude: _locationData?.longitude ?? 0,
        file: videoFile,
      );
      if (result) {
        showInfoSnackBar(context, AppStrings.fileSaved, color: Colors.green);
      } else {
        throw Exception(AppStrings.fileSaveFailed);
      }
    } on Exception catch (e) {
      showInfoSnackBar(
        context,
        AppStrings.fileUploadFailed + "(${e.toString()})",
        color: Colors.red,
      );
    }
    _claimNumber = null;
    _isRecording = false;
    return response;
  }

  bool get isRecording => _isRecording;

  String? get claimNumber => _claimNumber;
}
