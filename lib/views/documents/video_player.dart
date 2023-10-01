import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../widgets/buttons.dart';

class VideoWebView extends StatelessWidget {
  final String pageUrl;

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  VideoWebView({Key? key, required this.pageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video"),
        leading: const AppBackButton(),
      ),
      body: WebView(
        initialUrl: pageUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
