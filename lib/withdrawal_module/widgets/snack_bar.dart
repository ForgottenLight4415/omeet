import 'package:flutter/material.dart';

enum SnackBarType { none, success, error }

void showSnackBar(BuildContext context, String text, {SnackBarType type = SnackBarType.none}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: _snackBarColor(type),
    ),
  );
}

Color? _snackBarColor(SnackBarType type) {
  switch (type) {
    case SnackBarType.none:
      return null;
    case SnackBarType.success:
      return Colors.green;
    case SnackBarType.error:
      return Colors.red;
  }
}
