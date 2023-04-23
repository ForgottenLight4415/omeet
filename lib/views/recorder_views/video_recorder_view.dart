import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_background_video_recorder/flutter_bvr_platform_interface.dart';

import '../../widgets/buttons.dart';
import '../../data/models/audit.dart';
import '../../widgets/claim_details.dart';
import '../../utilities/video_recorder.dart';

class VideoPageConfig {
  final VideoRecorder videoRecorder;
  final Audit claim;

  const VideoPageConfig(this.videoRecorder, this.claim);
}

class VideoRecordView extends StatefulWidget {
  final VideoPageConfig config;

  const VideoRecordView({Key? key, required this.config}) : super(key: key);

  @override
  State<VideoRecordView> createState() => _VideoRecordViewState();
}

class _VideoRecordViewState extends State<VideoRecordView>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  /// Events to [_streamSubscription] are in the
  /// form of integers which stand for the following:
  /// 1: Recording
  /// 2: Not recording or stopped
  /// 3: Recorder busy. Probably initializing or finalizing internal state.
  late final StreamSubscription<int?> _streamSubscription;

  late final VideoRecorder _video;
  late CameraFacing _cameraFacing;
  bool _recorderBusy = false;
  bool _isRecording = false;



  @override
  void initState() {
    super.initState();
    _cameraFacing = CameraFacing.rearCamera;
    _video = widget.config.videoRecorder;
    getInitialRecordingStatus();
    listenRecordingState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
          title: const Text('Record video'),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 250.h,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _video.caseClaimNumber != null
                        ? "Recording in progress for claim number\n${_video.caseClaimNumber}"
                        : "Start recording for\n${widget.config.claim.hospital.id}",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: const Text("Rear camera"),
                          leading: Radio<CameraFacing>(
                            value: CameraFacing.rearCamera,
                            groupValue: _cameraFacing,
                            onChanged: (CameraFacing? cameraFacing) {
                              setState(() {
                                _cameraFacing =
                                    cameraFacing ?? CameraFacing.rearCamera;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text("Front camera"),
                          leading: Radio<CameraFacing>(
                            value: CameraFacing.frontCamera,
                            groupValue: _cameraFacing,
                            onChanged: (CameraFacing? cameraFacing) {
                              setState(() {
                                _cameraFacing =
                                    cameraFacing ?? CameraFacing.rearCamera;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_isRecording && !_recorderBusy) {
                        _video.caseClaimNumber = widget.config.claim.hospital.id;
                        await _video.startVideoRecording(_cameraFacing);
                        setState(() {});
                      } else if (!_isRecording && _recorderBusy) {
                        return;
                      } else {
                        await _video.stopVideoRecording(context);
                        setState(() {});
                      }
                    },
                    child: Text(
                      _isRecording ? "Stop Recording" : "Start Recording",
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: ClaimDetails(claim: widget.config.claim),
        ));
  }

  void getInitialRecordingStatus() async {
    _isRecording = await _video.getCurrentRecordingStatus() == 1;
    setState(() {});
  }

  void listenRecordingState() {
    _streamSubscription = _video.recorderState.listen((event) {
      switch (event) {
        case 1:
          _isRecording = true;
          _recorderBusy = true;
          setState(() {});
          break;
        case 2:
          _isRecording = false;
          _recorderBusy = false;
          setState(() {});
          break;
        case 3:
          _recorderBusy = true;
          setState(() {});
          break;
        case -1:
          _isRecording = false;
          setState(() {});
          break;
        default:
          return;
      }
    });
  }
}
