import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_video_recorder/flutter_bvr_platform_interface.dart';
import 'package:location/location.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_background_video_recorder/flutter_bvr.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/buttons.dart';
import '../../data/models/claim.dart';
import '../../widgets/snack_bar.dart';
import '../../utilities/app_constants.dart';
import '../../utilities/upload_dialog.dart';
import '../../views/meet_pages/details.dart';
import '../../utilities/video_record_config.dart';
import '../../data/repositories/data_upload_repo.dart';

class VideoPageConfig {
  final VideoRecorderConfig config;
  final Claim claim;

  const VideoPageConfig(this.config, this.claim);
}

class VideoRecordPage extends StatefulWidget {
  final VideoPageConfig config;

  const VideoRecordPage({Key? key, required this.config}) : super(key: key);

  @override
  State<VideoRecordPage> createState() => _VideoRecordPageState();
}

class _VideoRecordPageState extends State<VideoRecordPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final FlutterBackgroundVideoRecorder _videoRecorder;
  late final StreamSubscription<int?> _streamSubscription;
  late final SharedPreferences _preferences;
  late final VideoRecorderConfig _recorderConfig;

  bool _recorderBusy = false;
  bool _isRecording = false;

  CameraFacing _cameraFacing = CameraFacing.rearCamera;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    _recorderConfig = widget.config.config;
    _videoRecorder = _recorderConfig.getRecorder();
    getInitialRecordingStatus();
    listenRecordingState();
  }

  void initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
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
                    _recorderConfig.claimNumber != null
                        ? "Recording in progress for claim number\n${_recorderConfig.claimNumber}"
                        : "Start recording for\n${widget.config.claim.claimNumber}",
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
                        startVideoRecording();
                      } else if (!_isRecording && _recorderBusy) {
                        return;
                      } else {
                        stopVideoRecording(
                            await _videoRecorder.stopVideoRecording() ?? "");
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

  Future<void> getInitialRecordingStatus() async {
    int? _recordingStatus = await _videoRecorder.getVideoRecordingStatus();
    _isRecording = _recordingStatus == 1;
    setState(() {});
  }

  void listenRecordingState() {
    _streamSubscription = _videoRecorder.recorderState.listen((event) {
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

  void stopVideoRecording(String? filePath) async {
    String claimNumber = widget.config.claim.claimNumber;
    if (filePath != null) {
      File _videoFile = File(filePath);
      LocationData _locationData = _recorderConfig.locationData!;
      final DataUploadRepository _repository = DataUploadRepository();
      showSnackBar(context, AppStrings.startingUpload,
          type: SnackBarType.success);
      showProgressDialog(context);
      bool _result = await _repository.uploadData(
        claimNumber: claimNumber,
        latitude: _locationData.latitude ?? 0,
        longitude: _locationData.longitude ?? 0,
        file: _videoFile,
      );
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      Navigator.pop(context);
      if (_result) {
        showSnackBar(context, AppStrings.fileUploaded,
            type: SnackBarType.success);
        _videoFile.delete();
      } else {
        showSnackBar(context, AppStrings.fileUploadFailed,
            type: SnackBarType.error);
      }
      _recorderConfig.claimNumber = null;
      _recorderConfig.videoFile = null;
      setState(() {});
      _preferences.remove("video-recording-cn");
    }
  }

  void startVideoRecording() async {
    String claimNumber = widget.config.claim.claimNumber;
    _recorderConfig.setClaimNumber(claimNumber);
    _preferences.setString("video-recording-cn", claimNumber);
    await _videoRecorder.startVideoRecording(
        folderName: "BAGIC MCI Video Recordings",
        cameraFacing: _cameraFacing,
        notificationTitle: "BAGIC MCI background service",
        notificationText: "BAGIC MCI is recording a video in the background",
    );
    setState(() {});
  }
}
