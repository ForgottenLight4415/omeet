import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'base_card.dart';
import 'card_detail_text.dart';
import 'claim_options_tile.dart';

import '../data/models/audit.dart';

import '../utilities/app_constants.dart';
import '../utilities/screen_recorder.dart';
import '../utilities/screen_capture.dart';
import '../utilities/video_recorder.dart';
import '../utilities/claim_option_functions.dart';

class ClaimCard extends StatefulWidget {
  final Audit claim;
  final ScreenRecorder? screenRecorder;
  final ScreenCapture? screenCapture;
  final VideoRecorder? videoRecorder;

  const ClaimCard({
    Key? key,
    required this.claim,
    this.screenRecorder,
    this.screenCapture,
    this.videoRecorder,
  }) : super(key: key);

  @override
  State<ClaimCard> createState() => _ClaimCardState();
}

class _ClaimCardState extends State<ClaimCard> {
  String? _screenshotClaim;
  Color? _cardColor;

  @override
  void initState() {
    super.initState();
    _setCardColor();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.resolveWith(
                  (states) => TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
            ),
            padding: MaterialStateProperty.resolveWith(
                  (states) => EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 16.w,
                  ),
            ),
            shape: MaterialStateProperty.resolveWith(
                  (states) => RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                  ),
            ),
            elevation: MaterialStateProperty.resolveWith((states) => 3.0),
          ),
        ),
        iconTheme: IconThemeData(size: 20.w)
      ),
      child: BaseCard(
        onPressed: () => _openClaimMenu(context),
        card: Card(
          color: _cardColor,
          child: Container(
            constraints: BoxConstraints(minHeight: 250.h),
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.claim.hospital.id,
                  softWrap: false,
                  style: Theme.of(context).textTheme.headlineMedium
                ),
                SizedBox(height: 4.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CardDetailText(
                      title: AppStrings.hospitalName,
                      content: widget.claim.hospital.name,
                    ),
                    CardDetailText(
                      title: AppStrings.hospitalAddress,
                      content: widget.claim.hospital.address,
                    ),
                    CardDetailText(
                      title: AppStrings.authorityName,
                      content: widget.claim.hospital.nameOfAuthority,
                    ),
                    CardDetailText(
                      title: AppStrings.location,
                      content: widget.claim.hospital.location
                    ),
                    CardDetailText(
                        title: AppStrings.region,
                        content: widget.claim.hospital.region
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/hospital/claims",
                              arguments: widget.claim.hospital.id,
                            );
                          },
                          child: const FaIcon(FontAwesomeIcons.listCheck),
                        ),
                        ElevatedButton(
                          onPressed: () => videoCall(context: context, audit: widget.claim),
                          child: const FaIcon(FontAwesomeIcons.video),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/claim/details',
                              arguments: widget.claim,
                            );
                          },
                          child: const FaIcon(FontAwesomeIcons.circleInfo),
                        ),
                        ElevatedButton(
                          onPressed: () => _openClaimMenu(context),
                          child: const Text("More"),
                        ),
                      ],
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

  void _openClaimMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: 600.h),
      builder: (modalContext) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.arrowRotateLeft,
              label: "Update details",
              onPressed: () {
                Navigator.pop(modalContext);
                Navigator.pushNamed(
                  context,
                  '/update',
                  arguments: widget.claim.hospital.id,
                );
              },
            ),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.camera,
              label: "Capture image",
              onPressed: () {
                Navigator.pop(modalContext);
                captureImage(context: context, audit: widget.claim);
              },
            ),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.film,
              label: AppStrings.recordVideo,
              onPressed: () async {
                Navigator.pop(modalContext);
                await recordVideo(
                  context: context,
                  audit: widget.claim,
                  videoRecorder: widget.videoRecorder!,
                ).then((_) {
                  _setCardColor();
                });
              },
            ),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.microphone,
              label: AppStrings.recordAudio,
              onPressed: () {
                Navigator.pop(modalContext);
                recordAudio(context: context, audit: widget.claim);
              },
            ),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.mobileScreenButton,
              label: _getScreenshotText(),
              onPressed: () async {
                Navigator.pop(modalContext);
                await handleScreenshotService(
                  context: context,
                  screenCapture: widget.screenCapture!,
                  claimNumber: widget.claim.hospital.id,
                );
                _setCardColor();
              },
            ),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.fileLines,
              label: "Documents",
              onPressed: () {
                Navigator.pop(modalContext);
                Navigator.pushNamed(
                  context,
                  '/documents',
                  arguments: widget.claim.hospital.id,
                );
              },
            ),
            // ClaimPageTiles(
            //   faIcon: FontAwesomeIcons.fileAudio,
            //   label: "Audio recordings",
            //   onPressed: () {
            //     Navigator.pop(modalContext);
            //     Navigator.pushNamed(
            //       context,
            //       '/audio',
            //       arguments: DocumentPageArguments(
            //         widget.claim.hospital.id,
            //       ),
            //     );
            //   },
            // ),
            // ClaimPageTiles(
            //   faIcon: FontAwesomeIcons.fileVideo,
            //   label: "Videos",
            //   onPressed: () {
            //     Navigator.pop(modalContext);
            //     Navigator.pushNamed(
            //       context,
            //       '/videos',
            //       arguments: DocumentPageArguments(widget.claim.hospital.id),
            //     );
            //   },
            // ),
            // ClaimPageTiles(
            //   faIcon: FontAwesomeIcons.recordVinyl,
            //   label: _getScreenRecordText(),
            //   onPressed: () async {
            //     Navigator.pop(modalContext);
            //     await handleScreenRecordingService(
            //       context,
            //       widget.screenRecorder,
            //       widget.claim.claimNumber,
            //     );
            //     _setCardColor();
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  // String _getScreenRecordText() {
  //   if (widget.screenRecorder.isRecording) {
  //     if (widget.screenRecorder.claimNumber != widget.claim.claimNumber) {
  //       return "Stop for ${widget.screenRecorder.claimNumber}";
  //     } else {
  //       return "Stop recording screen";
  //     }
  //   }
  //   return "Record screen";
  // }

  String _getScreenshotText() {
    if (widget.screenCapture!.isServiceRunning) {
      if (widget.screenCapture!.claimNumber != widget.claim.hospital.id) {
        return "Stop screenshot service for ${widget.screenCapture!.claimNumber}";
      } else {
        return "Stop screenshot service";
      }
    }
    return "Start screenshot service";
  }

  void _setCardColor() async {
    _screenshotClaim = widget.screenCapture!.claimNumber;
    if (widget.screenRecorder!.isRecording) {
      setState(() {
        _cardColor = Colors.red.shade100;
      });
    } else if (_screenshotClaim != null &&
        _screenshotClaim == widget.claim.hospital.id) {
      setState(() {
        _cardColor = Colors.red.shade100;
      });
    } else if (widget.videoRecorder!.caseClaimNumber != null &&
        widget.videoRecorder!.caseClaimNumber == widget.claim.hospital.id) {
      setState(() {
        _cardColor = Colors.red.shade100;
      });
    } else {
      setState(() {
        _cardColor = null;
      });
    }
  }
}
