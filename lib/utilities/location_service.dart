import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '/utilities/app_permission_manager.dart';
import '/utilities/app_constants.dart';

class LocationService {
  final Location _location = Location();
  bool _serviceEnabled = false;

  Future<bool> _checkService(BuildContext context) async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(AppStrings.locationDisabled),
          content: const Text(AppStrings.locationExplanation),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                _serviceEnabled = await _location.requestService();
              },
              child: const Text("ENABLE"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text("CANCEL"),
            )
          ],
        ),
      );
    }
    return _serviceEnabled;
  }

  Future<LocationData> getLocation(BuildContext context) async {
    if (await _checkService(context) && (await locationPermission(context) ?? false)) {
      return await _location.getLocation();
    }
    throw Exception(AppStrings.locationError);
  }

  Future<bool> checkLocationStatus(BuildContext context) async {
    return await _checkService(context) && (await locationPermission(context) ?? false);
  }
}
