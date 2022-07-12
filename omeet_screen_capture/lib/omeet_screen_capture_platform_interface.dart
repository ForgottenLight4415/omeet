import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'omeet_screen_capture_method_channel.dart';

abstract class OmeetScreenCapturePlatform extends PlatformInterface {
  /// Constructs a OmeetScreenCapturePlatform.
  OmeetScreenCapturePlatform() : super(token: _token);

  static final Object _token = Object();

  static OmeetScreenCapturePlatform _instance = MethodChannelOmeetScreenCapture();

  /// The default instance of [OmeetScreenCapturePlatform] to use.
  ///
  /// Defaults to [MethodChannelOmeetScreenCapture].
  static OmeetScreenCapturePlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OmeetScreenCapturePlatform] when
  /// they register themselves.
  static set instance(OmeetScreenCapturePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> startService(String claimNumber) {
    throw UnimplementedError('startService(String) has not been implemented.');
  }

  Future<void> stopService() {
    throw UnimplementedError('stopService() has not been implemented.');
  }

  Future<bool?> isServiceRunning() async {
    throw UnimplementedError('isServiceRunning() has not been implemented.');
  }

  Future<String?> get claimNumber async {
    throw UnimplementedError('claimNumber has not been implemented.');
  }
}
