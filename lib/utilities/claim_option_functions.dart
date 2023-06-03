import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../data/models/audit.dart';
import 'show_snackbars.dart';
import 'camera_utility.dart';
import 'screen_capture.dart';
import 'screen_recorder.dart';
import 'video_recorder.dart';
import 'location_service.dart';
import 'app_permission_manager.dart';

import '../views/recorder_views/video_recorder_view.dart';
import '../views/recorder_views/audio_recorder_view.dart';

Future<bool> handleScreenshotService(
    {required BuildContext context,
    required String claimNumber,
    required ScreenCapture screenCapture}) async {
  if (!screenCapture.isServiceRunning) {
    final bool storagePermStatus = await storagePermission(context) ?? false;
    if (storagePermStatus) {
      return await screenCapture.startService(claimNumber: claimNumber);
    } else {
      showInfoSnackBar(
        context,
        "Storage permission is required to access this feature.",
        color: Colors.red,
      );
      return false;
    }
  } else {
    return await screenCapture.stopService();
  }
}

Future<bool> handleScreenRecordingService(
    {required BuildContext context,
    required String claimNumber,
    required ScreenRecorder screenRecorder}) async {
  if (!screenRecorder.isRecording) {
    final bool micPermStatus = await microphonePermission(context) ?? false;
    final bool storagePermStatus = await storagePermission(context) ?? false;

    if (micPermStatus && storagePermStatus) {
      await screenRecorder.startRecord(
        context: context,
        claimNumber: claimNumber,
      );
      return true;
    } else {
      showInfoSnackBar(
        context,
        "Microphone and storage permission is required to access this feature.",
        color: Colors.red,
      );
      return false;
    }
  } else {
    await screenRecorder.stopRecord(claimNumber: claimNumber, context: context);
    return true;
  }
}

Future<void> videoCall(
    {required BuildContext context, required Audit audit}) async {
  final bool cameraStatus = await cameraPermission(context) ?? false;
  final bool microphoneStatus = await microphonePermission(context) ?? false;
  // final bool storageStatus = await storagePermission(context) ?? false;

  final LocationService locationService = LocationService();
  final bool locationStatus =
      await locationService.checkLocationStatus(context);

  if (cameraStatus && microphoneStatus && locationStatus) {
    log("Starting meet");
    Navigator.pushNamed(context, '/claim/meeting', arguments: audit);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  } else {
    showInfoSnackBar(
      context,
      "Grant required permissions to access this feature",
      color: Colors.red,
    );
  }
}

Future<void> recordAudio(
    {required BuildContext context, required Audit audit}) async {
  final LocationService locationService = LocationService();
  final bool locationStatus =
      await locationService.checkLocationStatus(context);
  bool microphoneStatus = await microphonePermission(context) ?? false;
  bool storageStatus = await storagePermission(context) ?? false;
  if (microphoneStatus && storageStatus && locationStatus) {
    Navigator.pushNamed(
      context,
      '/record/audio',
      arguments: AudioRecordArguments(
        audit,
        await locationService.getLocation(context),
      ),
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  } else {
    showInfoSnackBar(
      context,
      "Microphone, storage and location permission is required to access this feature.",
      color: Colors.red,
    );
  }
}

Future<void> recordVideo(
    {required BuildContext context,
    required Audit audit,
    required VideoRecorder videoRecorder}) async {
  final bool cameraStatus = await cameraPermission(context) ?? false;
  final bool microphoneStatus = await microphonePermission(context) ?? false;
  final bool storageStatus = await storagePermission(context) ?? false;

  final LocationService locationService = LocationService();
  final bool locationStatus =
      await locationService.checkLocationStatus(context);

  if (cameraStatus && microphoneStatus && storageStatus && locationStatus) {
    log("Starting meet");
    videoRecorder.caseLocation = await locationService.getLocation(context);
    await Navigator.pushNamed(
      context,
      '/record/video',
      arguments: VideoPageConfig(videoRecorder, audit),
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  } else {
    showInfoSnackBar(
      context,
      "Camera, microphone, storage and location permission is required to access this feature.",
      color: Colors.red,
    );
  }
}

Future<void> captureImage(
    {required BuildContext context, required Audit audit}) async {
  final bool cameraStatus = await cameraPermission(context) ?? false;
  final bool microphoneStatus = await microphonePermission(context) ?? false;
  final bool storageStatus = await storagePermission(context) ?? false;

  final LocationService locationService = LocationService();
  final bool locationStatus =
  await locationService.checkLocationStatus(context);

  if (cameraStatus && microphoneStatus && storageStatus && locationStatus) {
    WidgetsFlutterBinding.ensureInitialized();
    List<CameraDescription>? _cameras;
    try {
      _cameras = await availableCameras();
      Navigator.pushNamed(context, '/capture/image',
        arguments: CameraCaptureArguments(
            _cameras,
            await locationService.getLocation(context),
            audit,
        ),
      );
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    } on CameraException catch (e) {
      showInfoSnackBar(
        context, "Failed to determine available cameras. (${e.description})",
        color: Colors.red,
      );
    }
  } else {
    showInfoSnackBar(
      context,
      "Camera, microphone, storage and location permission is required to access this feature.",
      color: Colors.red,
    );
  }
}