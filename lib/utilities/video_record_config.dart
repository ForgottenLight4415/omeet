import 'package:camera/camera.dart';
import 'package:location/location.dart';
import 'package:flutter_background_video_recorder/flutter_bvr.dart';

class VideoRecorderConfig {
  XFile? videoFile;
  String? claimNumber;
  LocationData? locationData;
  final FlutterBackgroundVideoRecorder _recorder = FlutterBackgroundVideoRecorder();

  VideoRecorderConfig({
        this.videoFile,
        this.claimNumber,
        this.locationData});

  FlutterBackgroundVideoRecorder getRecorder() {
    return _recorder;
  }

  void setOutFile(XFile? videoFile) {
    this.videoFile = videoFile;
  }

  void setClaimNumber(String? claimNumber) {
    this.claimNumber = claimNumber;
  }

  void setLocation(LocationData? locationData) {
    this.locationData = locationData;
  }
}
