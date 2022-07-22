import 'package:camera/camera.dart';


class VideoRecorderParams {
  static List<CameraDescription?>? camera;
  static CameraController? controller;
  static XFile? videoFile;
  static bool enableAudio = true;
  static String? claimNumber;
}
