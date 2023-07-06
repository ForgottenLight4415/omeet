import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:omeet_motor/blocs/home_bloc/get_claims_cubit.dart';
import 'package:omeet_motor/utilities/bridge_call.dart';
import 'package:omeet_motor/views/call_conclusion.dart';

import 'allocate_case_dialog.dart';
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
  final GetClaimsCubit cubit;
  final ScreenRecorder? screenRecorder;
  final ScreenCapture? screenCapture;
  final VideoRecorder? videoRecorder;
  final bool isEditable;
  final bool isRejected;

  const ClaimCard({
    Key? key,
    required this.claim,
    required this.cubit,
    this.screenRecorder,
    this.screenCapture,
    this.videoRecorder,
    this.isEditable = true,
    this.isRejected = false,
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
        onPressed: () async {
          await _openClaimMenu(context);
        },
        card: Card(
          color: _cardColor,
          child: Container(
            constraints: BoxConstraints(minHeight: 180.h),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.claim.claimId,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: CardDetailText(
                            title: AppStrings.district,
                            content: widget.claim.district,
                          ),
                        ),
                        Expanded(
                          child: CardDetailText(
                            title: AppStrings.policeStation,
                            content: widget.claim.policeStation,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: CardDetailText(
                            title: AppStrings.firNumber,
                            content: widget.claim.firNumber,
                          ),
                        ),
                        Expanded(
                          child: CardDetailText(
                            title: AppStrings.firDate,
                            content: widget.claim.firDate,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: CardDetailText(
                            title: AppStrings.accidentYear,
                            content: widget.claim.accidentYear,
                          ),
                        ),
                        Expanded(
                          child: CardDetailText(
                            title: AppStrings.accidentDate,
                            content: widget.claim.accidentDate,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: CardDetailText(
                            title: AppStrings.section,
                            content: widget.claim.section,
                          ),
                        ),
                        Expanded(
                          child: CardDetailText(
                            title: AppStrings.accusedVehicleNumber,
                            content: widget.claim.accused,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CardDetailText(
                            title: AppStrings.insuredName,
                            content: widget.claim.insuredName,
                          ),
                        ),
                        Expanded(
                          child: CardDetailText(
                            title: AppStrings.policyNumber,
                            content: widget.claim.policyNumber,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: widget.isEditable && !widget.isRejected
                          ? MainAxisAlignment.spaceAround
                          : MainAxisAlignment.start,
                      children: <Widget>[
                        widget.isEditable && !widget.isRejected
                            ? BlocProvider<CallCubit>(
                                create: (callContext) => CallCubit(),
                                child: BlocConsumer<CallCubit, CallState>(
                                  listener: _callListener,
                                  builder: (context, state) => ElevatedButton(
                                    onPressed: () async {
                                      log("Calling");
                                      bool result = await widget.claim.call(context);
                                      if (!result) {
                                        showSnackBar(context, "Phone number not available.", type: SnackBarType.error);
                                      }
                                    },
                                    child: const Icon(Icons.phone),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        widget.isEditable && !widget.isRejected
                            ? ElevatedButton(
                                onPressed: () async {
                                  await widget.claim.videoCall(context);
                                },
                                child: const FaIcon(FontAwesomeIcons.video),
                              )
                            : const SizedBox(),
                        widget.isEditable && !widget.isRejected
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
                    label: "Allocate case",
                    onPressed: () async {
                      Navigator.pop(modalContext);
                      _allocateDialog(context);
                    },
                  )
                : const SizedBox(),
            widget.isEditable && !widget.isRejected
              ? BlocProvider<CallCubit>(
                create: (context) => CallCubit(),
                child: BlocConsumer<CallCubit, CallState>(
                  listener: _callListener,
                  builder: (context, state) {
                    return ClaimPageTiles(
                      faIcon: FontAwesomeIcons.phone,
                      label: "Custom voice call",
                      onPressed: () async {
                        final List<String>? result = await customCallSetup(
                          context,
                          claimId: widget.claim.claimId,
                          customerMobileNumber: widget.claim.customerMobileNumber,
                        );
                        if (result != null) {
                          BlocProvider.of<CallCubit>(context).callClient(
                            claimId: result[0],
                            phoneNumber: result[2],
                            managerNumber: result[1],
                          );
                        }
                      },
                    );
                  },
                ),
            ) : const SizedBox(),
            widget.isEditable && !widget.isRejected
                ? ClaimPageTiles(
                    faIcon: FontAwesomeIcons.camera,
                    label: "Capture image",
                    onPressed: () {
                      Navigator.pop(modalContext);
                      captureImage(context, widget.claim);
                    },
                  )
                : const SizedBox(),
            widget.isEditable && !widget.isRejected
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
            widget.isEditable && !widget.isRejected
                ? ClaimPageTiles(
                    faIcon: FontAwesomeIcons.microphone,
                    label: AppStrings.recordAudio,
                    onPressed: () {
                      Navigator.pop(modalContext);
                      recordAudio(context, widget.claim);
                    },
                  )
                : const SizedBox(),
            // widget.isEditable && !widget.isRejected
            //     ? ClaimPageTiles(
            //         faIcon: FontAwesomeIcons.mobileScreenButton,
            //         label: _getScreenshotText(),
            //         onPressed: () async {
            //           Navigator.pop(modalContext);
            //           await handleScreenshotService(
            //             context,
            //             screenCapture: widget.screenCapture!,
            //             claimId: widget.claim.claimId,
            //           );
            //           _setCardColor();
            //         },
            //       )
            //     : const SizedBox(),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.fileLines,
              label: "Documents",
              onPressed: () {
                Navigator.pop(modalContext);
                Navigator.pushNamed(
                  context,
                  '/documents',
                  arguments: DocumentPageArguments(
                    widget.claim.claimId,
                    widget.isRejected || !widget.isEditable,
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
                    widget.claim.claimId,
                    widget.isRejected || !widget.isEditable,
                  ),
                );
              },
            ),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.fileVideo,
              label: "Video recordings",
              onPressed: () {
                Navigator.pop(modalContext);
                Navigator.pushNamed(
                  context,
                  '/videos',
                  arguments: DocumentPageArguments(
                    widget.claim.claimId,
                    widget.isRejected || !widget.isEditable,
                  ),
                );
              },
            ),
            widget.isEditable && !widget.isRejected
                ? ClaimPageTiles(
              faIcon: FontAwesomeIcons.circleCheck,
              label: "Final Conclusion",
              onPressed: () {
                Navigator.pop(modalContext);
                Navigator.pushNamed(context, "/final_conclusion", arguments: widget.claim);
              },
            ) : const SizedBox(),
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

  Future<void> _allocateDialog(BuildContext context) async {
    bool? result = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      builder: (context) => AllocateCaseDialog(caseId: widget.claim.claimId),
    );

    if (result != null && result) {
      widget.cubit.getClaims(context, forSelfAssignment: true);
    }
  }

  void _callListener(BuildContext context, CallState state) {
    if (state is CallLoading) {
      showSnackBar(context, AppStrings.connecting);
    } else if (state is CallReady) {
      showSnackBar(context, AppStrings.receiveCall, type: SnackBarType.success);
      Navigator.popAndPushNamed(
        context,
        "/call_conclusion",
        arguments: [
          state.managerPhoneNumber,
          state.customerPhoneNumber,
          state.caseId,
        ]
      );
    } else if (state is CallFailed) {
      showSnackBar(context, state.cause, type: SnackBarType.error);
    }
  }

  // String _getScreenshotText() {
  //   if (widget.screenCapture!.isServiceRunning) {
  //     if (widget.screenCapture!.claimNumber != widget.claim.claimId) {
  //       return "Stop screenshot service for ${widget.screenCapture!.claimNumber}";
  //     } else {
  //       return "Stop screenshot service";
  //     }
  //   }
  //   return "Start screenshot service";
  // }

  void _setCardColor() async {
    _screenshotClaim = widget.screenCapture!.claimNumber;
    if (widget.screenRecorder!.isRecording) {
      setState(() {
        _cardColor = Colors.red.shade100;
      });
    } else if (_screenshotClaim != null &&
        _screenshotClaim == widget.claim.claimId) {
      setState(() {
        _cardColor = Colors.red.shade100;
      });
    } else if (widget.videoRecorder!.caseClaimNumber != null &&
        widget.videoRecorder!.caseClaimNumber == widget.claim.claimId) {
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
