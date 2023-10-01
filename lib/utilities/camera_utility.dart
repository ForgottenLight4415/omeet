import 'package:camera/camera.dart';
import 'package:location/location.dart';

import '../data/models/claim.dart';

class CameraCaptureArguments {
  final List<CameraDescription> cameras;
  final LocationData locationData;
  final Claim claim;

  CameraCaptureArguments(this.cameras, this.locationData, this.claim);
}
