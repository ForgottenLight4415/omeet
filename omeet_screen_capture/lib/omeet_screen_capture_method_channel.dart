import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'omeet_screen_capture_platform_interface.dart';

/// An implementation of [OmeetScreenCapturePlatform] that uses method channels.
class MethodChannelOmeetScreenCapture extends OmeetScreenCapturePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('omeet_screen_capture');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> startService(String claimNumber) async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      await methodChannel.invokeMethod(
          'startScreenshotService',
        <String, String> {
            "claimNumber" : claimNumber
        }
      );
      return "Starting service";
    } else if (status.isDenied) {
      return "Permission denied";
    } else if (status.isPermanentlyDenied) {
      return "Permission denied. Open settings to grant permission.";
    }
    return null;
  }

  @override
  Future<bool?> isServiceRunning() async {
    return await methodChannel.invokeMethod('isServiceRunning');
  }

  @override
  Future<void> stopService() async {
    await methodChannel.invokeMethod('stopScreenshotService');
  }

  @override
  Future<String?> get claimNumber async {
    return await methodChannel.invokeMethod<String>('claimNumber');
  }
}
