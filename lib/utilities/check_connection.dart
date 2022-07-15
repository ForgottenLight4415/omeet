import 'package:flutter/material.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import 'app_constants.dart';

Future<bool> checkConnection(BuildContext context) async {
  if (!await SimpleConnectionChecker.isConnectedToInternet()) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(AppStrings.noInternet),
            content: const Text(
              AppStrings.looksLikeOffline + AppStrings.offlineSolution,
              textAlign: TextAlign.justify,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(AppStrings.ok),
              )
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
          );
        });
    return false;
  }
  return true;
}
