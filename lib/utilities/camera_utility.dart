import 'package:camera/camera.dart';
import 'package:location/location.dart';

import '../data/models/audit.dart';

class CameraCaptureArguments {
  final List<CameraDescription> cameras;
  final LocationData locationData;
  final Audit claim;

  CameraCaptureArguments(this.cameras, this.locationData, this.claim);
}
