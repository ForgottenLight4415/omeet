import 'package:flutter/material.dart';

void showInfoSnackBar(BuildContext context, message, {Color? color}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
    ),
  );
}
