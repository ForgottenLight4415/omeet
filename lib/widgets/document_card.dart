import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:omeet_motor/views/documents/doc_viewer.dart';
import 'package:omeet_motor/views/documents/video_player.dart';

import '../widgets/scaling_tile.dart';
import '../data/models/document.dart';

class DocumentCard extends StatelessWidget {
  final dynamic document;
  final DocumentType type;

  const DocumentCard({Key? key, required this.document, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: ScalingTile(
        onPressed: () async {
          if (type != DocumentType.video && type != DocumentType.audio) {
            Navigator.pushNamed(
              context,
              '/view/document',
              arguments: DocumentViewPageArguments(
                (document as Document).fileUrl,
                type,
              ),
            );
          } else {
            Navigator.pushNamed(
              context,
              '/view/audio-video',
              arguments: VideoWebViewArguments(
                  type == DocumentType.video
                    ? (document as Document).fileUrl
                    : (document as AudioRecording).callUrl,
                  type,
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
                        (document as Document).fileType,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        (document as Document).fileName,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      type == DocumentType.audio
                          ? Text(
                              "From: " + document.callFrom,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.fade,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          : const SizedBox(),
                      type == DocumentType.audio
                          ? Text(
                              "To: " + document.callTo,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.fade,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          : const SizedBox(),
                      SizedBox(height: 12.h),
                      Text(
                        document.uploadDateTime,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () => showDescription(context),
                        child: const Text("Show Details"),
                      )
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
    switch (type) {
      case DocumentType.file:
        if (document.fileUrl.split(".").last == "pdf") {
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
    switch (type) {
      case DocumentType.file:
        if (document.fileUrl.split(".").last == "pdf") {
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
                      Text((document as Document).fileDesc),
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
