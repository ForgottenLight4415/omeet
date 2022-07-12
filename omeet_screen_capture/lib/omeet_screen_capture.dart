
import 'omeet_screen_capture_platform_interface.dart';

class OmeetScreenCapture {
  Future<String?> getPlatformVersion() {
    return OmeetScreenCapturePlatform.instance.getPlatformVersion();
  }

  Future<void> startService(String claimNumber) {
    return OmeetScreenCapturePlatform.instance.startService(claimNumber);
  }

  Future<void> stopService() {
    return OmeetScreenCapturePlatform.instance.stopService();
  }

  Future<bool?> isServiceRunning() async {
    return OmeetScreenCapturePlatform.instance.isServiceRunning();
  }

  Future<String?> get claimNumber async {
    return OmeetScreenCapturePlatform.instance.claimNumber;
  }
}
