import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:omeet_motor/utilities/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_video_recorder/flutter_bvr.dart';
import 'package:flutter_background_video_recorder/flutter_bvr_platform_interface.dart';

import '../data/repositories/data_upload_repo.dart';
import '../widgets/snack_bar.dart';

class VideoRecorder {
  XFile? outputFile;
  String? caseClaimNumber;
  LocationData? caseLocation;
  late final FlutterBackgroundVideoRecorder _recorder;

  VideoRecorder(
      {XFile? videoFile, String? claimNumber, LocationData? locationData})
      : caseLocation = locationData,
        caseClaimNumber = claimNumber,
        outputFile = videoFile {
    _recorder = FlutterBackgroundVideoRecorder();
  }

  FlutterBackgroundVideoRecorder getRecorder() {
    return _recorder;
  }

  Future<int?> getCurrentRecordingStatus() async {
    return await _recorder.getVideoRecordingStatus();
  }

  Stream<int> get recorderState {
    return _recorder.recorderState;
  }

  Future<bool?> startVideoRecording(CameraFacing cameraFacing) async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setString("video-recording-cn", caseClaimNumber!);
    return await _recorder.startVideoRecording(
        folderName: AppStrings.videoStorageFolderName,
        cameraFacing: cameraFacing,
        notificationTitle: AppStrings.videoRecordingNotificationTitle,
        notificationText: AppStrings.videoRecordingNotificationText,
        showToast: false);
  }

  Future<void> stopVideoRecording(BuildContext context) async {
    String? filePath = await _recorder.stopVideoRecording();
    if (filePath != null) {
      final SharedPreferences _pref = await SharedPreferences.getInstance();
      final DataUploadRepository _repository = DataUploadRepository();
      LocationData _locationData = caseLocation!;
      File _videoFile = File(filePath);
      await _repository.uploadData(
          claimId: caseClaimNumber!,
          latitude: _locationData.latitude ?? 0,
          longitude: _locationData.longitude ?? 0,
          file: _videoFile,
          uploadNow: false,
      );
      showSnackBar(context, AppStrings.videoSaved, type: SnackBarType.success);
      caseClaimNumber = null;
      outputFile = null;
      _pref.remove("video-recording-cn");
    }
  }
}
