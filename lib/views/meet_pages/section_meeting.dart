import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';

import '../../utilities/show_snackbars.dart';
import '/data/models/claim.dart';
import '/data/providers/authentication_provider.dart';
import '/utilities/screen_recorder.dart';
import '/widgets/buttons.dart';
import '/widgets/scaling_tile.dart';

enum VideoMeetStatus { none, joining, inProgress, terminated, error }

class VideoMeetPage extends StatefulWidget {
  final Claim claim;

  const VideoMeetPage({Key? key, required this.claim}) : super(key: key);

  @override
  State<VideoMeetPage> createState() => _VideoMeetPageState();
}

class _VideoMeetPageState extends State<VideoMeetPage> with AutomaticKeepAliveClientMixin<VideoMeetPage>, WidgetsBindingObserver, TickerProviderStateMixin {
  // Video meet settings
  VideoMeetStatus _status = VideoMeetStatus.none;
  bool _isAudioOnly = false;
  bool _isAudioMuted = true;
  bool _isVideoMuted = true;

  List<CameraDescription>? _cameras;
  CameraController? _controller;
  int _activeCamera = 1;

  // Screen recorder settings
  ScreenRecorder? _screenRecorder;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addObserver(this);
    startCamera();
    _screenRecorder = ScreenRecorder();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  void startCamera() async {
    _cameras ??= await availableCameras();
    if (_cameras?.length == 1) {
      _activeCamera = 0;
    }
    _initializeCamera(_cameras![_activeCamera]);
  }

  void stopCamera() {
    _controller = null;
  }

  TextStyle customBodyTextOne(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_status == VideoMeetStatus.joining) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_status == VideoMeetStatus.inProgress) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Meeting in progress",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          ScalingTile(
            onPressed: () async {
              await _closeMeeting();
            },
            child: SizedBox(
              height: 70.h,
              width: 180.h,
              child: Card(
                color: Colors.red,
                child: Center(
                  child: Text(
                    "End meeting",
                    style: customBodyTextOne(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 30.h),
        Text(
          "Join meeting",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontFamily: 'Open Sans',
          ),
        ),
        SizedBox(height: 20.h),
        _cameraPreviewWidget(),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            VideoMeetToggleButton(
              toggleParameter: _isAudioMuted,
              primaryFaIcon: FontAwesomeIcons.microphoneSlash,
              secondaryFaIcon: FontAwesomeIcons.microphone,
              onPressed: () {
                _onAudioMutedChanged(!_isAudioMuted);
              },
            ),
            VideoMeetToggleButton(
              toggleParameter: _isVideoMuted,
              primaryFaIcon: FontAwesomeIcons.videoSlash,
              secondaryFaIcon: FontAwesomeIcons.video,
              onPressed: () {
                _onVideoMutedChanged(!_isVideoMuted);
              },
            ),
            VideoMeetToggleButton(
              toggleParameter: false,
              primaryFaIcon: FontAwesomeIcons.cameraRotate,
              secondaryFaIcon: FontAwesomeIcons.cameraRotate,
              onPressed: _onCameraToggleChanged,
            ),
            ScalingTile(
              onPressed: () async {
                await _screenRecorder!.startRecord(
                  claimNumber: widget.claim.claimNumber,
                );
                await _joinMeeting();
              },
              child: SizedBox(
                height: 80.h,
                width: 140.h,
                child: Card(
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0)),
                  child: Center(
                    child: Text(
                      "Join",
                      style: customBodyTextOne(context),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        SizedBox(
          width: 250.w,
          child: CheckboxListTile(
            value: _isAudioOnly,
            title: const Text(
              "Audio only mode",
            ),
            onChanged: (value) {
              _onAudioOnlyChanged(value!);
            },
          ),
        )
      ],
    );
  }

  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return SizedBox(
        height: 400,
        width: 225,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Container(
            color: Colors.black54,
            child: Center(
              child: Text(
                _isVideoMuted ? "Camera turned off" : "Camera is starting",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 400,
        width: 225,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: CameraPreview(_controller!),
        ),
      );
    }
  }

  Future<void> _initializeCamera(CameraDescription cameraDescription) async {
    if (_controller != null) {
      return _controller!.setDescription(cameraDescription);
    } else {
      return _initializeCameraController(cameraDescription);
    }
  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.max,
    );
    _controller = cameraController;
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInfoSnackBar(
          context,
          'Camera error ${cameraController.value.errorDescription}',
          color: Colors.red,
        );
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInfoSnackBar(
            context,
            'You have denied camera access.',
            color: Colors.red,
          );
          break;
        case 'AudioAccessDenied':
          showInfoSnackBar(
            context,
            'You have denied audio access.',
            color: Colors.red,
          );
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

  void _showCameraException(CameraException e) {
    showInfoSnackBar(
      context,
      'Error: ${e.code}\n${e.description}',
      color: Colors.red,
    );
  }

  _onAudioOnlyChanged(bool value) {
    setState(() {
      _isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      _isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      _isVideoMuted = value;
    });
    if (value) {
      stopCamera();
    } else {
      startCamera();
    }
  }

  void _onCameraToggleChanged() {
    if (_cameras?.length == 1) {
      showInfoSnackBar(context, "No other cameras found");
      return;
    }
    if (_controller == null) {
      showInfoSnackBar(context, "Camera is turned off");
      return;
    }
    if (_activeCamera == 0) {
      _activeCamera = 1;
    } else {
      _activeCamera = 0;
    }
    _initializeCamera(_cameras![_activeCamera]);
  }

  void _onConferenceWillJoin(message) {
    setState(() {
      _status = VideoMeetStatus.joining;
    });
  }

  void _onConferenceJoined(message) async {
    setState(() {
      _status = VideoMeetStatus.inProgress;
    });
  }

  void _onConferenceTerminated(url, error) async {
    _onClose();
  }

  void _onClose() async {
    setState(() {
      _status = VideoMeetStatus.terminated;
    });
    await _screenRecorder!.stopRecord(claimNumber: widget.claim.claimNumber, context: context);
  }

  Future<void> _joinMeeting() async {
    try {
      final Map<FeatureFlag, bool> featureFlags = {
        FeatureFlag.isWelcomePageEnabled: false,
        FeatureFlag.isCallIntegrationEnabled: false,
        FeatureFlag.isPipEnabled: false,
        FeatureFlag.isCalendarEnabled: false,
        FeatureFlag.isLiveStreamingEnabled: false,
        FeatureFlag.isRecordingEnabled: false,
      };
      final String meetId = widget.claim.insuredPerson.insuredContactNumber;
      var options = JitsiMeetingOptions(
          roomNameOrUrl: meetId,
          serverUrl: "https://hi.omeet.in/$meetId",
          subject: "Meeting with ${widget.claim.insuredPerson.insuredName}",
          userDisplayName: "OMeet Agent",
          userEmail: await AuthenticationProvider.getEmail(),
          isAudioOnly: _isAudioOnly,
          isAudioMuted: _isAudioMuted,
          isVideoMuted: _isVideoMuted,
          featureFlags: featureFlags);
      await JitsiMeetWrapper.joinMeeting(
        options: options,
        listener: JitsiMeetingListener(
            onConferenceWillJoin: _onConferenceWillJoin,
            onConferenceJoined: _onConferenceJoined,
            onConferenceTerminated: _onConferenceTerminated,
            onClosed: _onClose),
      );
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> _closeMeeting() async {
    await JitsiMeetWrapper.hangUp();
    setState(() {
      _status = VideoMeetStatus.terminated;
    });
    await _screenRecorder!.stopRecord(claimNumber: widget.claim.claimNumber, context: context);
  }

  @override
  bool get wantKeepAlive {
    return true;
  }
}
