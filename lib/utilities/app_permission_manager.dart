import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:omeet_motor/utilities/show_snackbars.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool?> cameraPermission(BuildContext context) async {
  return _permissionRequestInterface(
    context: context,
    permission: Permission.camera,
    icon: const Icon(Icons.camera_alt, color: Colors.red),
    message: "Access to camera is needed to use this feature.",
  );
}

Future<bool?> microphonePermission(BuildContext context) async {
  return _permissionRequestInterface(
    context: context,
    permission: Permission.microphone,
    icon: const Icon(Icons.mic, color: Colors.red),
    message: "Access to microphone is needed to use this feature.",
  );
}

Future<bool?> locationPermission(BuildContext context) async {
  return _permissionRequestInterface(
    context: context,
    permission: Permission.location,
    icon: const Icon(Icons.location_on, color: Colors.red),
    message: "Access to location is needed to use this feature.",
  );
}

Future<bool?> _permissionRequestInterface(
    {required BuildContext context,
      required Permission permission,
      required Widget icon,
      required String message}) async {
  PermissionStatus? status = await permission.status;
  log(permission.toString() + " " + status.toString());
  if (status.isGranted || status.isLimited) {
    return true;
  } else {
    return await showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
        icon: icon,
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => _permissionHandler(context, permission),
            child: const Text("ALLOW"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("DENY"),
          ),
        ],
      ),
    );
  }
}

void _permissionHandler(BuildContext context, Permission permission) async {
  final PermissionStatus permResult = await permission.request();
  if (permResult.isGranted) {
    Navigator.pop(context, true);
  } else if (permResult.isDenied || permResult.isPermanentlyDenied) {
    showInfoSnackBar(
      context,
      "Grant the permission in app settings",
      color: Colors.orange,
    );
    Navigator.pop(context);
    openAppSettings();
  }
}
