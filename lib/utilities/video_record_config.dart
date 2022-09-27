import 'package:camera/camera.dart';
import 'package:location/location.dart';

class VideoRecorderConfig {
  List<CameraDescription?>? cameraList;
  CameraController? controller;
  XFile? videoFile;
  bool enableAudio;
  String? claimNumber;
  LocationData? locationData;

  VideoRecorderConfig(
      {this.cameraList,
        this.controller,
        this.videoFile,
        this.enableAudio = true,
        this.claimNumber,
        this.locationData});

  void setCameraList(List<CameraDescription?> cameras) {
    cameraList = cameras;
  }

  void changeCameraController(CameraController? cameraController) {
    controller = cameraController;
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
