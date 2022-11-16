import 'dart:async';
import 'dart:io';
import 'package:flutter_background_video_recorder/flutter_bvr.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:omeet_motor/views/meet_pages/details.dart';

import '../../data/models/claim.dart';
import '../../data/repositories/data_upload_repo.dart';
import '../../utilities/app_constants.dart';
import '../../utilities/upload_dialog.dart';
import '../../utilities/video_record_config.dart';
import '../../widgets/buttons.dart';
import '../../widgets/snack_bar.dart';

class VideoPageConfig {
  final VideoRecorderConfig config;
  final String? claimNumber;
  final Claim? claim;

  const VideoPageConfig(this.config, this.claimNumber, this.claim);
}

class VideoRecordPage extends StatefulWidget {
  final VideoPageConfig config;

  const VideoRecordPage({Key? key, required this.config}) : super(key: key);

  @override
  State<VideoRecordPage> createState() => _VideoRecordPageState();
}

class _VideoRecordPageState extends State<VideoRecordPage> with WidgetsBindingObserver, TickerProviderStateMixin {
  FlutterBackgroundVideoRecorder? _videoRecorder;
  StreamSubscription<int?>? _streamSubscription;
  late final VideoRecorderConfig args;

  bool _recorderBusy = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    args = widget.config.config;
    _videoRecorder = args.getRecorder();
    getInitialRecordingStatus();
    listenRecordingState();
  }


  @override
  void dispose() {
    _streamSubscription?.cancel();
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
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            height: 150.h,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    args.claimNumber != null
                        ? "Recording in progress for claim number\n${args
                        .claimNumber}"
                        : "Start recording for\n${widget.config.claimNumber}",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_isRecording && !_recorderBusy) {
                        startVideoRecording();
                      } else if (!_isRecording && _recorderBusy) {
                        return;
                      } else {
                        stopVideoRecording(await _videoRecorder?.stopVideoRecording() ?? "");
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
          child: ClaimDetails(claim: widget.config.claim!),
        )
    );
  }

  Future<void> getInitialRecordingStatus() async {
    _isRecording = await _videoRecorder?.getVideoRecordingStatus() == 1;
    setState(() {});
  }

  void listenRecordingState() {
    _streamSubscription = _videoRecorder?.recorderState.listen((event) {
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
    if (filePath != null) {
      File _videoFile = File(filePath);
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
        args.claimNumber = null;
        args.videoFile = null;
        setState(() {});
      }
    }
  }

  void startVideoRecording() async {
    args.setClaimNumber(widget.config.claimNumber);
    await _videoRecorder?.startVideoRecording();
    setState(() {});
  }
}
