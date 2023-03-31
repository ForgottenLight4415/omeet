import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:omeet_motor/utilities/bridge_call.dart';

import 'base_card.dart';
import 'card_detail_text.dart';
import 'claim_options_tile.dart';

import 'snack_bar.dart';
import '../data/models/claim.dart';
import '../data/models/document.dart';

import '../utilities/app_constants.dart';
import '../utilities/screen_recorder.dart';
import '../utilities/screen_capture.dart';
import '../utilities/video_recorder.dart';
import '../utilities/claim_option_functions.dart';

import '../blocs/call_bloc/call_cubit.dart';

class ClaimCard extends StatefulWidget {
  final Claim claim;
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
                widget.claim.claimNumber,
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
                    title: AppStrings.customerName,
                    content: widget.claim.insuredName,
                  ),
                  CardDetailText(
                    title: AppStrings.customerAddress,
                    content: widget.claim.customerAddress,
                  ),
                  CardDetailText(
                    title: AppStrings.phoneNumber,
                    content: widget.claim.insuredContactNumber,
                  ),
                  CardDetailText(
                    title: AppStrings.phoneNumberAlt,
                    content:
                        widget.claim.insuredAltContactNumber != AppStrings.blank
                            ? widget.claim.insuredAltContactNumber
                            : AppStrings.unavailable,
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: widget.isEditable
                        ? MainAxisAlignment.spaceAround
                        : MainAxisAlignment.start,
                    children: <Widget>[
                      widget.isEditable
                          ? BlocProvider<CallCubit>(
                              create: (callContext) => CallCubit(),
                              child: BlocConsumer<CallCubit, CallState>(
                                listener: _callListener,
                                builder: (context, state) => ElevatedButton(
                                  onPressed: () async {
                                    await widget.claim.call(context);
                                  },
                                  child: const Icon(Icons.phone),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      widget.isEditable
                          ? ElevatedButton(
                              onPressed: () async {
                                await widget.claim.videoCall(context);
                              },
                              child: const FaIcon(FontAwesomeIcons.video),
                            )
                          : const SizedBox(),
                      widget.isEditable
                          ? ElevatedButton(
                              onPressed: () async {
                                await widget.claim.sendMessageModal(
                                  context,
                                );
                              },
                              child: const Icon(Icons.mail),
                            )
                          : const SizedBox(),
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
            !widget.isEditable
                ? ClaimPageTiles(
                    faIcon: FontAwesomeIcons.plus,
                    label: "Assign to self",
                    onPressed: () {
                      Navigator.pop(modalContext);
                      widget.claim.assignToSelf(context);
                    },
                  )
                : const SizedBox(),
            widget.isEditable
                ? BlocProvider<CallCubit>(
                    create: (context) => CallCubit(),
                    child: BlocConsumer<CallCubit, CallState>(
                      listener: _callListener,
                      builder: (context, state) {
                        return ClaimPageTiles(
                          faIcon: FontAwesomeIcons.phoneAlt,
                          label: "Voice call",
                          onPressed: () async {
                            if (await widget.claim.call(context)) {
                              Navigator.pop(modalContext);
                            }
                          },
                        );
                      },
                    ),
                  )
                : const SizedBox(),
            BlocProvider<CallCubit>(
              create: (context) => CallCubit(),
              child: BlocConsumer<CallCubit, CallState>(
                listener: _callListener,
                builder: (context, state) {
                  return ClaimPageTiles(
                    faIcon: FontAwesomeIcons.phoneAlt,
                    label: "Custom voice call",
                    onPressed: () async {
                      if (await customCallSetup(
                        context,
                        claimNumber: widget.claim.claimNumber,
                        insuredContactNumber: widget.claim.insuredContactNumber,
                      )) {
                        Navigator.pop(modalContext);
                      }
                    },
                  );
                },
              ),
            ),
            widget.isEditable
                ? ClaimPageTiles(
                    faIcon: FontAwesomeIcons.video,
                    label: "Video call",
                    onPressed: () {
                      Navigator.pop(modalContext);
                      videoCall(context, widget.claim);
                    },
                  )
                : const SizedBox(),
            widget.isEditable
                ? ClaimPageTiles(
                    faIcon: FontAwesomeIcons.camera,
                    label: "Capture image",
                    onPressed: () {
                      Navigator.pop(modalContext);
                      captureImage(context, widget.claim);
                    },
                  )
                : const SizedBox(),
            widget.isEditable
                ? ClaimPageTiles(
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
                  )
                : const SizedBox(),
            widget.isEditable
                ? ClaimPageTiles(
                    faIcon: FontAwesomeIcons.microphone,
                    label: AppStrings.recordAudio,
                    onPressed: () {
                      Navigator.pop(modalContext);
                      recordAudio(context, widget.claim);
                    },
                  )
                : const SizedBox(),
            widget.isEditable
                ? ClaimPageTiles(
                    faIcon: FontAwesomeIcons.mobileAlt,
                    label: _getScreenshotText(),
                    onPressed: () async {
                      Navigator.pop(modalContext);
                      await handleScreenshotService(
                        context,
                        widget.screenCapture!,
                        widget.claim.claimNumber,
                      );
                      _setCardColor();
                    },
                  )
                : const SizedBox(),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.fileAlt,
              label: "Documents",
              onPressed: () {
                Navigator.pop(modalContext);
                Navigator.pushNamed(
                  context,
                  '/documents',
                  arguments: DocumentPageArguments(
                    widget.claim.claimNumber,
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
                    widget.claim.claimNumber,
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
                    widget.claim.claimNumber,
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
      if (widget.screenCapture!.claimNumber != widget.claim.claimNumber) {
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
        _screenshotClaim == widget.claim.claimNumber) {
      setState(() {
        _cardColor = Colors.red.shade100;
      });
    } else if (widget.videoRecorder!.claimNumber != null &&
        widget.videoRecorder!.claimNumber == widget.claim.claimNumber) {
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
