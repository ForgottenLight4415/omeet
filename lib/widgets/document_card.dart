import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:omeet_motor/views/documents/doc_viewer.dart';

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
                type == DocumentType.audio
                    ? document.callUrl
                    : document.fileUrl,
                type,
              ),
            );
          } else {
            Navigator.pushNamed(
              context,
              '/view/audio-video',
              arguments: type == DocumentType.video
                  ? document.fileUrl
                  : document.callUrl,
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
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10.w),
                  constraints: BoxConstraints(
                    maxHeight: 150.h,
                    minHeight: 150.h,
                    maxWidth: 110.w,
                    minWidth: 110.w,
                  ),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(14.r)),
                  child: Center(
                    child: FaIcon(
                      type == DocumentType.file
                          ? FontAwesomeIcons.fileAlt
                          : type == DocumentType.video
                              ? FontAwesomeIcons.fileVideo
                              : FontAwesomeIcons.fileAudio,
                      size: 50.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      type == DocumentType.file
                          ? "PDF Document"
                          : type == DocumentType.video
                              ? "Video file"
                              : "Audio file",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "ID: ${document.id}",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    type == DocumentType.audio
                        ? Text(
                            "From: " + document.callFrom,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.fade,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        : const SizedBox(),
                    type == DocumentType.audio
                        ? Text(
                            "To: " + document.callTo,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.fade,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        : const SizedBox(),
                    Text(
                      document.uploadDateTime,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
