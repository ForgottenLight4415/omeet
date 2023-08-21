import 'package:camera/camera.dart';
import 'package:location/location.dart';

import '../data/models/withdrawal.dart';

class CameraCaptureArguments {
  final List<CameraDescription> cameras;
  final LocationData locationData;
  final Withdrawal claim;

  CameraCaptureArguments(this.cameras, this.locationData, this.claim);
}
