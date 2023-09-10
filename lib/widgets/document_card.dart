import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flowder_v2/flowder.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../data/providers/document_provider.dart';
import '../utilities/show_snackbars.dart';
import '../views/documents/doc_viewer.dart';
import '../views/documents/video_player.dart';
import '../widgets/scaling_tile.dart';
import '../data/models/document.dart';

class DocumentCard extends StatefulWidget {
  final dynamic document;
  final DocumentType type;

  const DocumentCard({Key? key, required this.document, required this.type})
      : super(key: key);

  @override
  State<DocumentCard> createState() => _DocumentCardState();
}

class _DocumentCardState extends State<DocumentCard> {
  late final String _savePath;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _setPath();
    if (!mounted) return;
  }
  void _setPath() async {
    String downloadsPath = (await DownloadsPath.downloadsDirectory())?.path ?? "";
    String _localPath = downloadsPath + Platform.pathSeparator + 'ICICI-MFI';
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    _savePath = _localPath;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: ScalingTile(
        onPressed: () async {
          if (widget.type != DocumentType.video && widget.type != DocumentType.audio) {
            Navigator.pushNamed(
              context,
              '/view/document',
              arguments: DocumentViewPageArguments(
                (widget.document as Document).fileUrl,
                widget.type,
              ),
            );
          } else {
            Navigator.pushNamed(
                context,
                '/view/audio-video',
                arguments: VideoWebViewArguments(
                  widget.type == DocumentType.video
                      ? (widget.document as Document).fileUrl
                      : (widget.document as AudioRecording).callUrl,
                  widget.type,
                )
            );
          }
        },
        child: Card(
          child: Container(
            margin: EdgeInsets.all(10.w),
            constraints: BoxConstraints(
              minHeight: 170.h,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  constraints: BoxConstraints(
                    maxHeight: 180.h,
                    minHeight: 150.h,
                    maxWidth: 110.w,
                    minWidth: 110.w,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Center(
                    child: FaIcon(
                      _getCardIcon(),
                      size: 50.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        (widget.document as Document).fileType,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        (widget.document as Document).fileName,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      widget.type == DocumentType.audio
                          ? Text(
                        "From: " + widget.document.callFrom,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                          : const SizedBox(),
                      widget.type == DocumentType.audio
                          ? Text(
                        "To: " + widget.document.callTo,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                          : const SizedBox(),
                      SizedBox(height: 12.h),
                      Text(
                        widget.document.uploadDateTime,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () => showDescription(context),
                            child: const Text("Show Details"),
                          ),
                          widget.type != DocumentType.audio
                              ? TextButton(
                            onPressed: () => downloadDocument(context),
                            child: const Text("Download"),
                          )
                              : const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCardIcon() {
    switch (widget.type) {
      case DocumentType.file:
        if (widget.document.fileUrl.split(".").last == "pdf") {
          return FontAwesomeIcons.fileLines;
        }
        return FontAwesomeIcons.fileImage;
      case DocumentType.audio:
        return FontAwesomeIcons.fileAudio;
      case DocumentType.video:
        return FontAwesomeIcons.fileVideo;
      case DocumentType.image:
        return FontAwesomeIcons.fileImage;
    }
  }

  String _getCardTitle() {
    switch (widget.type) {
      case DocumentType.file:
        if (widget.document.fileUrl.split(".").last == "pdf") {
          return "Document";
        }
        return "Image";
      case DocumentType.audio:
        return "Call Recording";
      case DocumentType.video:
        return "Video";
      case DocumentType.image:
        return "Image";
    }
  }

  void downloadDocument(BuildContext context) async {
    final options = DownloaderUtils(
      progressCallback: (current, total) {
        final progress = (current / total) * 100;
        log('Downloading: $progress');
      },
      file: File('$_savePath/${(widget.document as Document).fileName}'),
      progress: ProgressImplementation(),
      onDone: () {
        showInfoSnackBar(
          context,
          "Download completed - $_savePath/${(widget.document as Document).fileName}",
          color: Colors.green,
        );
        log('$_savePath/${(widget.document as Document).fileName}');
      },
      deleteOnCancel: true,
    );
    showInfoSnackBar(
      context,
      "Starting Download - ${(widget.document as Document).fileType}",
      color: Colors.green,
    );
    await Flowder.download(
      await DocumentProvider().getDocument((widget.document as Document).fileUrl),
      options,
    );
  }

  void showDescription(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Details"),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Type: ${_getCardTitle()}"),
                    const SizedBox(height: 16.0),
                    Text((widget.document as Document).fileDesc),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
