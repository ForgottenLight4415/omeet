import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../data/models/document.dart';
import '../../widgets/buttons.dart';

class VideoWebViewArguments {
  final String pageUrl;
  final DocumentType type;

  VideoWebViewArguments(this.pageUrl, this.type);
}

class VideoWebView extends StatelessWidget {
  final VideoWebViewArguments arguments;

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  VideoWebView({Key? key, required this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          arguments.type == DocumentType.video
            ? "Video"
            : "Audio",
        ),
        leading: const AppBackButton(),
      ),
      body: WebView(
        initialUrl: arguments.pageUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
