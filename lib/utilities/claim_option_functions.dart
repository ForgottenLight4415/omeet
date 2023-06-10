import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:omeet_motor/utilities/screen_capture.dart';
import 'package:omeet_motor/utilities/screen_recorder.dart';
import 'package:omeet_motor/utilities/video_recorder.dart';

import '../data/models/claim.dart';
import '../views/recorder_pages/video_recorder_page.dart';
import 'app_permission_manager.dart';
import 'camera_utility.dart';
import 'location_service.dart';
import 'show_snackbars.dart';
import '../views/recorder_pages/audio_recorder_page.dart';

Future<bool> handleScreenshotService(BuildContext context,
    {required ScreenCapture screenCapture, required String claimNumber}) async {
  if (!screenCapture.isServiceRunning) {
    bool storageStatus = await storagePermission(context) ?? false;
    if (storageStatus) {
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

Future<bool> handleScreenRecordingService(BuildContext context,
    {required ScreenRecorder screenRecorder,
    required String claimNumber}) async {
  if (!screenRecorder.isRecording) {
    return await _startScreenRecord(context, screenRecorder, claimNumber);
  } else {
    return await _stopScreenRecord(context, screenRecorder, claimNumber);
  }
}

Future<bool> _startScreenRecord(BuildContext context,
    ScreenRecorder screenRecorder, String claimNumber) async {
  // Check permissions
  bool microphoneStatus = await microphonePermission(context) ?? false;
  bool storageStatus = await storagePermission(context) ?? false;

  // If permissions are granted
  if (microphoneStatus && storageStatus) {
    await screenRecorder.startRecord(
      context: context,
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

Future<bool> _stopScreenRecord(BuildContext context,
    ScreenRecorder screenRecorder, String claimNumber) async {
  await screenRecorder.stopRecord(claimNumber: claimNumber, context: context);
  return true;
}

Future<void> videoCall(BuildContext context, Claim claim) async {
  bool cameraStatus = await cameraPermission(context) ?? false;
  bool microphoneStatus = await microphonePermission(context) ?? false;
  bool storageStatus = await storagePermission(context) ?? false;

  if (cameraStatus && microphoneStatus && storageStatus) {
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
  LocationData? locationData = await _getLocationData(context);
  bool microphoneStatus = await microphonePermission(context) ?? false;
  bool storageStatus = await storagePermission(context) ?? false;
  if (microphoneStatus && storageStatus && locationData != null) {
    Navigator.pushNamed(context, '/record/audio',
        arguments: AudioRecordArguments(claim, locationData));
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  } else {
    showInfoSnackBar(context,
        "Microphone, storage and location permission is required to access this feature.",
        color: Colors.red);
  }
}

Future<void> recordVideo(
    BuildContext context, Claim claim, VideoRecorder videoRecorder) async {
  LocationData? locationData = await _getLocationData(context);
  if (locationData == null) {
    showInfoSnackBar(
        context, "Location permission is required to access this feature.",
        color: Colors.red);
    return;
  }
  videoRecorder.caseLocation = locationData;
  await Navigator.pushNamed(
    context,
    '/record/video',
    arguments: VideoPageConfig(
      videoRecorder,
      claim,
    ),
  );
}

Future<void> captureImage(BuildContext context, Claim claim) async {
  showInfoSnackBar(context, "Checking permissions...");
  LocationData? _locationData = await _getLocationData(context);
  bool _cameraStatus = await cameraPermission(context) ?? false;
  bool _microphoneStatus = await microphonePermission(context) ?? false;
  bool _storageStatus = await storagePermission(context) ?? false;
  if (_cameraStatus &&
      _microphoneStatus &&
      _storageStatus &&
      _locationData != null) {
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
      showInfoSnackBar(
          context, "Failed to determine available cameras. (${e.description})",
          color: Colors.red);
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
