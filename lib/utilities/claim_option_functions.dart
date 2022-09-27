import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:omeet_motor/utilities/screen_capture.dart';
import 'package:omeet_motor/utilities/screen_recorder.dart';
import 'package:omeet_motor/utilities/video_record_config.dart';

import '../data/models/claim.dart';
import '../views/recorder_pages/video_record.dart';
import 'app_permission_manager.dart';
import 'camera_utility.dart';
import 'location_service.dart';
import 'show_snackbars.dart';
import '../views/recorder_pages/audio_record.dart';

Future<bool> handleScreenshotService(BuildContext context, ScreenCapture screenCapture, String claimNumber) async {
  if (!screenCapture.isServiceRunning) {
    return await _startScreenshotService(context, screenCapture, claimNumber);
  } else {
    return await _stopScreenshotService(context, screenCapture);
  }
}

Future<bool> _startScreenshotService(BuildContext context, ScreenCapture screenCapture, String claimNumber) async {
  bool storageStatus = await storagePermission();
  if (storageStatus) {
    return await screenCapture.startService(claimNumber: claimNumber);
  } else {
    showInfoSnackBar(context, "Storage permission is required to access this feature.", color: Colors.red);
    return false;
  }
}

Future<bool> _stopScreenshotService(BuildContext context, ScreenCapture screenCapture) async {
  return await screenCapture.stopService();
}

Future<bool> handleScreenRecordingService(BuildContext context, ScreenRecorder screenRecorder, String claimNumber) async {
  if (!screenRecorder.isRecording) {
    return await _startScreenRecord(
      context,
      screenRecorder,
      claimNumber,
    );
  } else {
    return await _stopScreenRecord(
      context,
      screenRecorder,
      claimNumber,
    );
  }
}

Future<bool> _startScreenRecord(BuildContext context, ScreenRecorder screenRecorder, String claimNumber) async {
  // Check permissions
  bool _microphoneStatus = await microphonePermission();
  bool _storageStatus = await storagePermission();

  // If permissions are granted
  if (_microphoneStatus && _storageStatus) {
    await screenRecorder.startRecord(
      claimNumber: claimNumber,
    );
    return true;
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Microphone and storage permission is required to access this feature.",
        ),
      ),
    );
    return false;
  }
}

Future<bool> _stopScreenRecord(BuildContext context, ScreenRecorder screenRecorder, String claimNumber) async {
  await screenRecorder.stopRecord(claimNumber: claimNumber, context: context);
  return true;
}

Future<void> videoCall(BuildContext context, Claim claim) async {
  showInfoSnackBar(context, "Checking permissions...");
  bool cameraStatus = await cameraPermission();
  bool microphoneStatus = await microphonePermission();
  bool storageStatus = await storagePermission();
  if (cameraStatus && microphoneStatus && storageStatus) {
    log("Starting meet");
    Navigator.pushNamed(context, '/claim/meeting', arguments: claim);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Camera, microphone and storage permission is required to access this feature.",
        ),
      ),
    );
  }
}

Future<void> recordAudio(BuildContext context, Claim claim) async {
  showInfoSnackBar(context, "Checking permissions...");
  LocationData? locationData = await _getLocationData(context);
  bool microphoneStatus = await microphonePermission();
  bool storageStatus = await storagePermission();
  if (microphoneStatus && storageStatus && locationData != null) {
    Navigator.pushNamed(context, '/record/audio', arguments: AudioRecordArguments(claim, locationData));
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  } else {
    showInfoSnackBar(context, "Microphone, storage and location permission is required to access this feature.", color: Colors.red);
  }
}

Future<void> recordVideo(BuildContext context, Claim claim, VideoRecorderConfig videoRecorderConfig) async {
  showInfoSnackBar(context, "Checking permissions...");
  LocationData? locationData = await _getLocationData(context);
  bool cameraStatus = await cameraPermission();
  bool microphoneStatus = await microphonePermission();
  bool storageStatus = await storagePermission();
  if (cameraStatus && microphoneStatus && storageStatus && locationData != null) {
    WidgetsFlutterBinding.ensureInitialized();
    List<CameraDescription>? _cameras;
    try {
      _cameras = await availableCameras();
      videoRecorderConfig.setCameraList(_cameras);
      videoRecorderConfig.setLocation(locationData);
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      await Navigator.pushNamed(
        context,
        '/record/video',
        arguments: VideoPageConfig(videoRecorderConfig, claim.claimNumber, claim),
      );
    } on CameraException catch (e) {
      showInfoSnackBar(context, "Failed to determine available cameras. (${e.description})", color: Colors.red);
    }
  } else {
    showInfoSnackBar(
      context,
      "Camera, microphone, storage and location permission is required to access this feature.",
      color: Colors.red,
    );
  }
}

Future<void> captureImage(BuildContext context, Claim claim) async {
  showInfoSnackBar(context, "Checking permissions...");
  LocationData? _locationData = await _getLocationData(context);
  bool _cameraStatus = await cameraPermission();
  bool _microphoneStatus = await microphonePermission();
  bool _storageStatus = await storagePermission();
  if (_cameraStatus && _microphoneStatus && _storageStatus && _locationData != null) {
    WidgetsFlutterBinding.ensureInitialized();
    List<CameraDescription>? _cameras;
    try {
      _cameras = await availableCameras();
      Navigator.pushNamed(
        context,
        '/capture/image',
        arguments: CameraCaptureArguments(_cameras, _locationData, claim),
      );
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    } on CameraException catch (e) {
      showInfoSnackBar(context, "Failed to determine available cameras. (${e.description})", color: Colors.red);
    }
  } else {
    showInfoSnackBar(
      context,
      "Camera, microphone, storage and location permission is required to access this feature.",
      color: Colors.red,
    );
  }
}

Future<LocationData?> _getLocationData(BuildContext context) async {
  LocationData? _locationData;
  LocationService _locationService = LocationService();
  try {
    _locationData = await _locationService.getLocation(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
  }
  return _locationData;
}
