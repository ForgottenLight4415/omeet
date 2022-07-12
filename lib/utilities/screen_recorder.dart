import 'dart:developer';
import 'dart:io';

import 'package:ed_screen_recorder/ed_screen_recorder.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rc_clone/data/repositories/data_upload_repo.dart';
import 'package:rc_clone/utilities/app_constants.dart';
import 'package:rc_clone/utilities/upload_dialog.dart';

class ScreenRecorder {
  EdScreenRecorder? _edScreenRecorder;
  bool _isRecording = false;
  String? _claimNumber;

  ScreenRecorder() {
    _edScreenRecorder = EdScreenRecorder();
  }

  Future<Map<String, dynamic>> startRecord({required String claimNumber}) async {
    log("Starting screen record");
    Directory? directory = await getExternalStorageDirectory();
    Directory? _saveDirectory = await Directory("${directory!.path}/ScreenRecordings").create();
    var response = await _edScreenRecorder!.startRecordScreen(
      fileName: "${claimNumber}_${DateTime.now().microsecondsSinceEpoch}",
      dirPathToSave: _saveDirectory.path,
      audioEnable: true,
    );
    _claimNumber = claimNumber;
    _isRecording = true;
    return response;
  }

  Future<Map<String, dynamic>> stopRecord({required String claimNumber, required BuildContext context}) async {
    var response = await _edScreenRecorder?.stopRecord();
    File _videoFile = response!['file'];
    final DataUploadRepository _repository = DataUploadRepository();
    showProgressDialog(context);
    bool _result = await _repository.uploadData(
      claimNumber: claimNumber,
      latitude: 0,
      longitude: 0,
      file: _videoFile,
    );
    Navigator.pop(context);
    if (_result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.fileUploaded),
          backgroundColor: Colors.green,
        ),
      );
      _videoFile.delete();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.fileUploadFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
    _claimNumber = null;
    _isRecording = false;
    return response;
  }

  bool get isRecording => _isRecording;

  String? get claimNumber => _claimNumber;
}
