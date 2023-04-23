import 'dart:developer';

import 'package:flutter/material.dart';

import '../data/models/claim.dart';
import 'app_permission_manager.dart';
import 'show_snackbars.dart';

Future<void> videoCall(BuildContext context, Claim claim) async {
  showInfoSnackBar(context, "Checking permissions...");
  bool cameraStatus = await cameraPermission();
  bool microphoneStatus = await microphonePermission();
  bool storageStatus = await storagePermission();
  if (cameraStatus && microphoneStatus && storageStatus) {
    log("Starting meet");
    Navigator.pushNamed(context, '/claim/meeting', arguments: claim);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Camera, microphone and storage permission is required to access this feature.",
        ),
      ),
    );
  }
}