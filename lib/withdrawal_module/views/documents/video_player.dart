import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../data/models/document.dart';
import '../../widgets/buttons.dart';

class VideoWebViewArguments {
  final String pageUrl;
  final DocumentType type;

  VideoWebViewArguments(this.pageUrl, this.type);
}

class VideoWebView extends StatefulWidget {
  final VideoWebViewArguments arguments;


  const VideoWebView({Key? key, required this.arguments}) : super(key: key);

  @override
  State<VideoWebView> createState() => _VideoWebViewState();
}

class _VideoWebViewState extends State<VideoWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController.fromPlatformCreationParams(
      const PlatformWebViewControllerCreationParams()
    );
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadRequest(Uri.parse(widget.arguments.pageUrl));
    log("URL: ${widget.arguments.pageUrl}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.arguments.type == DocumentType.video
            ? "Video"
            : "Audio",
        ),
        leading: const AppBackButton(),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
