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

  Future<bool> startRecord({
    required BuildContext context,
    required String claimNumber,
  }) async {
    log("Starting screen record");
    if (_isRecording) {
      return true;
    }
    LocationService locationService = LocationService();
    _locationData = await locationService.getLocation(context);

    Directory? directory = await getExternalStorageDirectory();
    Directory? _saveDirectory = await Directory(
      "${directory!.path}/ScreenRecordings",
    ).create();

    final RecordOutput response =
    await _edScreenRecorder.startRecordScreen(
      fileName: "${claimNumber}_${DateTime.now().microsecondsSinceEpoch}",
      dirPathToSave: _saveDirectory.path,
      audioEnable: true,
      height: context.size?.height.toInt() ?? 0,
      width: context.size?.width.toInt() ?? 0,
    );
    _claimNumber = claimNumber;
    _isRecording = true;
    return response.success;
  }

  Future<RecordOutput> stopRecord(
      {required String claimNumber, required BuildContext context}) async {
    RecordOutput response = await _edScreenRecorder.stopRecord();
    File videoFile = response.file;

    final DataUploadRepository _repository = DataUploadRepository();
    try {
      bool result = await _repository.uploadData(
        claimNumber: claimNumber,
        latitude: _locationData?.latitude ?? 0,
        longitude: _locationData?.longitude ?? 0,
        file: videoFile,
      );
      if (result) {
        showInfoSnackBar(context, AppStrings.fileSaved, color: Colors.green);
        videoFile.delete();
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
