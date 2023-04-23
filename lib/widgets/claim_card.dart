import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'base_card.dart';
import 'card_detail_text.dart';
import 'claim_options_tile.dart';
import 'snack_bar.dart';

import '../data/models/audit.dart';
import '../data/models/document.dart';

import '../utilities/bridge_call.dart';
import '../utilities/app_constants.dart';
import '../utilities/screen_recorder.dart';
import '../utilities/screen_capture.dart';
import '../utilities/video_recorder.dart';
import '../utilities/claim_option_functions.dart';

import '../blocs/call_bloc/call_cubit.dart';

class ClaimCard extends StatefulWidget {
  final Audit claim;
  final ScreenRecorder? screenRecorder;
  final ScreenCapture? screenCapture;
  final VideoRecorder? videoRecorder;
  final bool isEditable;

  const ClaimCard({
    Key? key,
    required this.claim,
    this.screenRecorder,
    this.screenCapture,
    this.videoRecorder,
    this.isEditable = true,
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
    if (widget.isEditable) {
      _setCardColor();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      onPressed: () async {
        await _openClaimMenu(context);
      },
      card: Card(
        color: _cardColor,
        child: Container(
          constraints: BoxConstraints(minHeight: 250.h),
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.claim.hospital.id,
                softWrap: false,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                      overflow: TextOverflow.fade,
                    ),
              ),
              SizedBox(height: 8.h),
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
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      BlocProvider<CallCubit>(
                        create: (callContext) => CallCubit(),
                        child: BlocConsumer<CallCubit, CallState>(
                          listener: _callListener,
                          builder: (context, state) => ElevatedButton(
                            onPressed: () async {
                              if (await customCallSetup(
                                context,
                                claimNumber: widget.claim.hospital.id,
                              )) {
                                Navigator.pop(context);
                              }
                            },
                            child: const FaIcon(FontAwesomeIcons.phone),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          videoCall(context, widget.claim);
                        },
                        child: const FaIcon(FontAwesomeIcons.video),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await widget.claim.sendMessageModal(
                            context,
                          );
                        },
                        child: const Icon(Icons.mail),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await _openClaimMenu(context);
                        },
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
    );
  }

  Future<void> _openClaimMenu(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: 600.h),
      builder: (modalContext) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.listCheck,
              label: "Claims",
              onPressed: () {
                Navigator.pop(modalContext);
                Navigator.pushNamed(
                    context,
                    "/hospital/claims",
                    arguments: widget.claim.hospital.id,
                );
              },
            ),
            BlocProvider<CallCubit>(
              create: (context) => CallCubit(),
              child: BlocConsumer<CallCubit, CallState>(
                listener: _callListener,
                builder: (context, state) {
                  return ClaimPageTiles(
                    faIcon: FontAwesomeIcons.phone,
                    label: "Custom voice call",
                    onPressed: () async {
                      if (await customCallSetup(
                        context,
                        claimNumber: widget.claim.hospital.id,
                      )) {
                        Navigator.pop(modalContext);
                      }
                    },
                  );
                },
              ),
            ),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.video,
              label: "Video call",
              onPressed: () {
                Navigator.pop(modalContext);
                videoCall(context, widget.claim);
              },
            ),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.camera,
              label: "Capture image",
              onPressed: () {
                Navigator.pop(modalContext);
                captureImage(context, widget.claim);
              },
            ),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.film,
              label: AppStrings.recordVideo,
              onPressed: () async {
                Navigator.pop(modalContext);
                await recordVideo(
                  context,
                  widget.claim,
                  widget.videoRecorder!,
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
                recordAudio(context, widget.claim);
              },
            ),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.mobileScreenButton,
              label: _getScreenshotText(),
              onPressed: () async {
                Navigator.pop(modalContext);
                await handleScreenshotService(
                  context,
                  widget.screenCapture!,
                  widget.claim.hospital.id,
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
                  arguments: DocumentPageArguments(
                    widget.claim.hospital.id,
                    !widget.isEditable,
                  ),
                );
              },
            ),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.fileAudio,
              label: "Audio recordings",
              onPressed: () {
                Navigator.pop(modalContext);
                Navigator.pushNamed(
                  context,
                  '/audio',
                  arguments: DocumentPageArguments(
                    widget.claim.hospital.id,
                    !widget.isEditable,
                  ),
                );
              },
            ),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.fileVideo,
              label: "Videos",
              onPressed: () {
                Navigator.pop(modalContext);
                Navigator.pushNamed(
                  context,
                  '/videos',
                  arguments: DocumentPageArguments(
                    widget.claim.hospital.id,
                    !widget.isEditable,
                  ),
                );
              },
            ),
            ClaimPageTiles(
                faIcon: FontAwesomeIcons.info,
                label: "Details",
                onPressed: () {
                  Navigator.pop(modalContext);
                  Navigator.pushNamed(context, '/claim/details',
                      arguments: widget.claim);
                })
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

  void _callListener(BuildContext context, CallState state) {
    if (state is CallLoading) {
      showSnackBar(context, AppStrings.connecting);
    } else if (state is CallReady) {
      showSnackBar(context, AppStrings.receiveCall, type: SnackBarType.success);
    } else if (state is CallFailed) {
      showSnackBar(context, state.cause, type: SnackBarType.error);
    }
  }

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
