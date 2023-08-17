import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:omeet_motor/blocs/home_bloc/get_claims_cubit.dart';
import 'package:omeet_motor/data/providers/claim_provider.dart';
import 'package:omeet_motor/utilities/bridge_call.dart';

import '../utilities/document_utilities.dart';
import 'allocate_case_dialog.dart';
import 'base_card.dart';
import 'card_detail_text.dart';
import 'claim_options_tile.dart';

import 'snack_bar.dart';
import '../data/models/claim.dart';
import '../data/models/document.dart';

import '../utilities/app_constants.dart';
import '../utilities/screen_recorder.dart';
import '../utilities/video_recorder.dart';
import '../utilities/claim_option_functions.dart';

import '../blocs/call_bloc/call_cubit.dart';

class ClaimCard extends StatefulWidget {
  final Claim claim;
  final GetClaimsCubit cubit;
  final ScreenRecorder? screenRecorder;
  final VideoRecorder? videoRecorder;
  final ClaimType claimType;

  const ClaimCard({
    Key? key,
    required this.claim,
    required this.cubit,
    required this.claimType,
    this.screenRecorder,
    this.videoRecorder,
  }) : super(key: key);

  @override
  State<ClaimCard> createState() => _ClaimCardState();
}

class _ClaimCardState extends State<ClaimCard> {
  Color? _cardColor;

  @override
  void initState() {
    super.initState();
    if (widget.claimType == ClaimType.accepted) {
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
          iconTheme: IconThemeData(size: 20.w)),
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
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),
                ),
                const SizedBox(height: 4.0),
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
            widget.claimType == ClaimType.allocated || widget.claimType == ClaimType.rejected
                ? ClaimPageTiles(
                    faIcon: FontAwesomeIcons.plus,
                    label: widget.claimType == ClaimType.allocated
                        ? "Allocate case"
                        : "Request case",
                    onPressed: () async {
                      Navigator.pop(modalContext);
                      _allocateDialog(context);
                    },
                  )
                : const SizedBox(),
            // widget.claimType == ClaimType.accepted
            //     ? BlocProvider<CallCubit>(
            //         create: (callContext) => CallCubit(),
            //         child: BlocConsumer<CallCubit, CallState>(
            //           listener: _callListener,
            //           builder: (context, state) => ClaimPageTiles(
            //             onPressed: () async {
            //               log("Calling");
            //               bool result = await widget.claim.call(context);
            //               if (!result) {
            //                 showSnackBar(context, "Phone number not available.",
            //                     type: SnackBarType.error);
            //               }
            //             },
            //             faIcon: FontAwesomeIcons.phone,
            //             label: "Voice Call",
            //           ),
            //         ),
            //       )
            //     : const SizedBox(),
            widget.claimType == ClaimType.accepted
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
                              customerMobileNumber:
                                  widget.claim.customerMobileNumber,
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
                  )
                : const SizedBox(),
            widget.claimType == ClaimType.accepted
                ? ClaimPageTiles(
                    onPressed: () async {
                      await widget.claim.videoCall(context);
                    },
                    faIcon: FontAwesomeIcons.video,
                    label: "Video Meeting",
                  )
                : const SizedBox(),
            // widget.claimType == ClaimType.accepted
            //     ? ClaimPageTiles(
            //         onPressed: () async {
            //           await widget.claim.sendMessageModal(
            //             context,
            //           );
            //         },
            //         faIcon: FontAwesomeIcons.message,
            //         label: "Send Message",
            //       )
            //     : const SizedBox(),
            widget.claimType == ClaimType.accepted
                ? ClaimPageTiles(
                    faIcon: FontAwesomeIcons.camera,
                    label: "Capture image",
                    onPressed: () {
                      Navigator.pop(modalContext);
                      captureImage(context, widget.claim);
                    },
                  )
                : const SizedBox(),
            widget.claimType == ClaimType.accepted
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
            widget.claimType == ClaimType.accepted
                ? ClaimPageTiles(
                    faIcon: FontAwesomeIcons.microphone,
                    label: AppStrings.recordAudio,
                    onPressed: () {
                      Navigator.pop(modalContext);
                      recordAudio(context, widget.claim);
                    },
                  )
                : const SizedBox(),
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
                    widget.claimType != ClaimType.accepted,
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
                    widget.claimType != ClaimType.accepted,
                  ),
                );
              },
            ),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.fileVideo,
              label: "Recordings",
              onPressed: () {
                Navigator.pop(modalContext);
                Navigator.pushNamed(
                  context,
                  '/videos',
                  arguments: DocumentPageArguments(
                    widget.claim.claimId,
                    widget.claimType != ClaimType.accepted,
                  ),
                );
              },
            ),
            widget.claimType == ClaimType.accepted
                ? ClaimPageTiles(
                    faIcon: FontAwesomeIcons.peopleGroup,
                    label: "Reporting",
                    onPressed: () async {
                      Navigator.pop(modalContext);
                      await DocumentUtilities.documentUploadDialog(
                          context, widget.claim.claimId, DocumentType.audio,
                          noFileReporting: true);
                    },
                  )
                : const SizedBox(),
            widget.claimType == ClaimType.accepted
                ? ClaimPageTiles(
                    faIcon: FontAwesomeIcons.circleCheck,
                    label: "Final Conclusion",
                    onPressed: () {
                      Navigator.pop(modalContext);
                      Navigator.pushNamed(context, "/final_conclusion",
                          arguments: widget.claim);
                    },
                  )
                : const SizedBox(),
            ClaimPageTiles(
                faIcon: FontAwesomeIcons.info,
                label: "Details",
                onPressed: () {
                  Navigator.pop(modalContext);
                  Navigator.pushNamed(context, '/claim/details',
                      arguments: widget.claim);
                })
          ],
        ),
      ),
    );
  }

  Future<void> _allocateDialog(BuildContext context) async {
    bool? result = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      builder: (context) => AllocateCaseDialog(caseId: widget.claim.claimId),
    );

    if (result != null && result) {
      widget.cubit.getClaims(context);
    }
  }

  void _callListener(BuildContext context, CallState state) {
    if (state is CallLoading) {
      showSnackBar(context, AppStrings.connecting);
    } else if (state is CallReady) {
      showSnackBar(context, AppStrings.receiveCall, type: SnackBarType.success);
      Navigator.popAndPushNamed(context, "/call_conclusion", arguments: [
        state.managerPhoneNumber,
        state.customerPhoneNumber,
        state.caseId,
      ]);
    } else if (state is CallFailed) {
      showSnackBar(context, state.cause, type: SnackBarType.error);
    }
  }

  void _setCardColor() async {
    if (widget.screenRecorder!.isRecording) {
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
