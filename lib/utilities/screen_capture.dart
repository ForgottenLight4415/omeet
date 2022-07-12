import 'dart:developer';

import 'package:omeet_screen_capture/omeet_screen_capture.dart';
import 'package:rc_clone/data/providers/app_server_provider.dart';

class ScreenCapture {
  OmeetScreenCapture? _omeetScreenCapture;
  bool _isServiceRunning = false;
  String? _claimNumber;

  ScreenCapture() {
    _omeetScreenCapture = OmeetScreenCapture();
  }

  Future<bool> startService({required String claimNumber}) async {
    log("Starting screenshot service for $claimNumber");
    if (_omeetScreenCapture != null) {
      if (!_isServiceRunning) {
        await _omeetScreenCapture?.startService(claimNumber);
        _claimNumber = claimNumber;
        _isServiceRunning = true;
        return true;
      }
      return false;
    } else {
      throw const ServerException(code: 1000, cause: "Service not initialized");
    }
  }

  Future<bool> stopService() async {
    log("Stopping screenshot service for $_claimNumber");
    if (_omeetScreenCapture != null) {
      if (_isServiceRunning) {
        await _omeetScreenCapture?.stopService();
        _claimNumber = null;
        _isServiceRunning = false;
        return true;
      }
      return false;
    } else {
      throw const ServerException(code: 1000, cause: "Service not initialized");
    }
  }

  bool get isServiceRunning => _isServiceRunning;

  String? get claimNumber => _claimNumber;
}