import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:location/location.dart';
import 'package:wakelock/wakelock.dart';

import '../../data/repositories/data_upload_repo.dart';
import '../../utilities/app_constants.dart';
import '../../utilities/upload_dialog.dart';
import '../../utilities/video_record_config.dart';
import '../../widgets/buttons.dart';
import '../../widgets/snack_bar.dart';

class VideoPageConfig {
  final VideoRecorderConfig config;
  final String? claimNumber;

  const VideoPageConfig(this.config, this.claimNumber);
}

class VideoRecordPage extends StatefulWidget {
  final VideoPageConfig config;

  const VideoRecordPage({Key? key, required this.config}) : super(key: key);

  @override
  State<VideoRecordPage> createState() => _VideoRecordPageState();
}

class _VideoRecordPageState extends State<VideoRecordPage> with WidgetsBindingObserver, TickerProviderStateMixin {
  late final VideoRecorderConfig args;

  @override
  void initState() {
    super.initState();
    args = widget.config.config;
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);
  }

  @override
  void dispose() {
    _ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    final CameraController? _controller = args.controller;
    if (_controller != null && !_controller.value.isRecordingVideo) {
      _controller.dispose();
      args.changeCameraController(null);
    }
    super.dispose();
  }

  // #docregion AppLifecycle
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("Lifecycle state changed: $state");
    final CameraController? cameraController = args.controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }
  // #enddocregion AppLifecycle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Record video'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            args.claimNumber != null
                ? "Recording in progress for claim number ${args.claimNumber}"
                : "Start recording for ${widget.config.claimNumber}",
          ),
          _captureControlRowWidget(),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _cameraTogglesRowWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    final CameraController? cameraController = args.controller;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.videocam),
          color: Colors.red,
          onPressed: cameraController != null
              && cameraController.value.isInitialized
              && !cameraController.value.isRecordingVideo
              ? onVideoRecordButtonPressed
              : null,
        ),
        IconButton(
          icon: cameraController != null
              && cameraController.value.isRecordingPaused
              ? const Icon(Icons.play_arrow)
              : const Icon(Icons.pause),
          color: Colors.red,
          onPressed: cameraController != null
              && cameraController.value.isInitialized
              && cameraController.value.isRecordingVideo
              ? (cameraController.value.isRecordingPaused)
              ? onResumeButtonPressed
              : onPauseButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.red,
          onPressed: cameraController != null
              && cameraController.value.isInitialized
              && cameraController.value.isRecordingVideo
              ? onStopButtonPressed
              : null,
        ),
      ],
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];
    void onChanged(CameraDescription? description) {
      if (description == null) {
        return;
      }
      onNewCameraSelected(description);
    }
    if (args.cameraList!.isEmpty) {
      _ambiguate(SchedulerBinding.instance)?.addPostFrameCallback((_) async {
        showSnackBar(context, 'No camera found.', type: SnackBarType.error);
      });
      return const Text('None');
    } else {
      for (final CameraDescription? cameraDescription in args.cameraList!) {
        toggles.add(
          SizedBox(
            width: 90.0,
            child: RadioListTile<CameraDescription>(
              title: Icon(getCameraLensIcon(cameraDescription!.lensDirection)),
              groupValue: args.controller?.description,
              value: cameraDescription,
              onChanged: args.controller != null
                  && args.controller!.value.isRecordingVideo
                  ? null : onChanged,
            ),
          ),
        );
      }
    }
    return Row(children: toggles);
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();


  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final CameraController? oldController = args.controller;
    if (oldController != null) {
      // `controller` needs to be set to null before getting disposed,
      // to avoid a race condition when we use the controller that is being
      // disposed. This happens when camera permission dialog shows up,
      // which triggers `didChangeAppLifecycleState`, which disposes and
      // re-creates the controller.
      args.changeCameraController(null);
      await oldController.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: args.enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    args.changeCameraController(cameraController);

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showSnackBar(context, 'Camera error ${cameraController.value.errorDescription}', type: SnackBarType.error);
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showSnackBar(context, 'You have denied camera access.', type: SnackBarType.error);
          break;
        case 'CameraAccessDeniedWithoutPrompt':
        // iOS only
          showSnackBar(context, 'Please go to Settings app to enable camera access.', type: SnackBarType.error);
          break;
        case 'CameraAccessRestricted':
        // iOS only
          showSnackBar(context, 'Camera access is restricted.', type: SnackBarType.error);
          break;
        case 'AudioAccessDenied':
          showSnackBar(context, 'You have denied audio access.', type: SnackBarType.error);
          break;
        case 'AudioAccessDeniedWithoutPrompt':
        // iOS only
          showSnackBar(context, 'Please go to Settings app to enable audio access.', type: SnackBarType.error);
          break;
        case 'AudioAccessRestricted':
        // iOS only
          showSnackBar(context, 'Audio access is restricted.', type: SnackBarType.error);
          break;
        case 'cameraPermission':
        // Android & web only
          showSnackBar(context, 'Unknown permission error.', type: SnackBarType.error);
          break;
        default:
          _showCameraException(e);
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((XFile? file) async {
      Wakelock.disable();
      if (mounted) {
        setState(() {});
      }
      if (file != null) {
        args.videoFile = file;
        File _videoFile = File(args.videoFile!.path);
        LocationData _locationData = args.locationData!;
        final DataUploadRepository _repository = DataUploadRepository();
        showSnackBar(
          context,
          AppStrings.startingUpload,
          type: SnackBarType.success,
        );
        showProgressDialog(context);
        bool _result = await _repository.uploadData(
          claimNumber: args.claimNumber ?? "NULL",
          latitude: _locationData.latitude ?? 0,
          longitude: _locationData.longitude ?? 0,
          file: _videoFile,
        );
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        Navigator.pop(context);
        if (_result) {
          showSnackBar(
            context,
            AppStrings.fileUploaded,
            type: SnackBarType.success,
          );
          _videoFile.delete();
          args.videoFile = null;
        }
      }
    });
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
      showSnackBar(context, 'Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
      showSnackBar(context, 'Video recording resumed');
    });
  }

  Future<void> startVideoRecording() async {
    Wakelock.enable();
    final CameraController? cameraController = args.controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showSnackBar(context, 'Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      args.setClaimNumber(widget.config.claimNumber);
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      args.setClaimNumber(null);
      _showCameraException(e);
      return;
    }
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = args.controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      args.claimNumber = null;
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      if (cameraController.value.isRecordingVideo) {
        args.claimNumber = args.claimNumber;
      }
      _showCameraException(e);
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    final CameraController? cameraController = args.controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    final CameraController? cameraController = args.controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  void _showCameraException(CameraException e) {
    log("${e.code}, ${e.description}");
    showSnackBar(context, 'Error: ${e.code}\n${e.description}', type: SnackBarType.error);
  }

  /// Returns a suitable camera icon for [direction].
  IconData getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        throw ArgumentError('Unknown lens direction');
    }
  }

  T? _ambiguate<T>(T? value) => value;
}
