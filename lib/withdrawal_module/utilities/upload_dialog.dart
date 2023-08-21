import 'package:flutter/material.dart';

void showProgressDialog(BuildContext context, {String? label, String? content}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title: Text(label ?? "Uploading file"),
        content: Row(
          children: <Widget>[
            const CircularProgressIndicator(),
            const SizedBox(width: 20.0),
            Expanded(
              child: Text(
                content ?? "Uploading in progress. Do not close application.",
                softWrap: true,
                maxLines: 2,
              ),
            )
          ],
        ),
      ),
    ),
  );
}