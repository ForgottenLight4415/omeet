import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utilities/screen_capture.dart';
import '../utilities/screen_recorder.dart';
import '../utilities/video_recorder.dart';
import 'base_card.dart';
import 'snack_bar.dart';
import 'card_detail_text.dart';
import 'claim_options_tile.dart';
import '../utilities/claim_options_functions.dart';

import '../data/models/claim.dart';
import '../data/models/document.dart';

import '../utilities/bridge_call.dart';
import '../utilities/app_constants.dart';

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
          if (widget.isEditable) {
            await _openClaimMenu(context);
          }
        },
        card: Card(
          color: _cardColor,
          child: Container(
            constraints: BoxConstraints(minHeight: 180.h),
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.claim.claimNumber,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context).textTheme.headlineMedium
                ),
                SizedBox(height: 4.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CardDetailText(
                      title: AppStrings.patientName,
                      content: widget.claim.patient.name,
                    ),
                    CardDetailText(
                      title: AppStrings.patientGender,
                      content: widget.claim.patient.gender,
                    ),
                    CardDetailText(
                      title: AppStrings.patientAge,
                      content: widget.claim.patient.age,
                    ),
                    CardDetailText(
                      title: AppStrings.phoneNumber,
                      content: widget.claim.insuredPerson.insuredContactNumber,
                    ),
                    SizedBox(height: 4.h),
                    widget.isEditable
                      ? Row(
                      mainAxisAlignment: widget.isEditable
                          ? MainAxisAlignment.spaceAround
                          : MainAxisAlignment.start,
                      children: <Widget>[
                        BlocProvider<CallCubit>(
                          create: (callContext) => CallCubit(),
                          child: BlocConsumer<CallCubit, CallState>(
                            listener: _callListener,
                            builder: (context, state) => ElevatedButton(
                              onPressed: () => widget.claim.call(context),
                              child: const Icon(Icons.phone),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => widget.claim.videoCall(context),
                          child: const FaIcon(FontAwesomeIcons.video),
                        ),
                        ElevatedButton(
                          onPressed: () => widget.claim.sendMessageModal(context),
                          child: const Icon(Icons.mail),
                        ),
                        ElevatedButton(
                          onPressed: () => _openClaimMenu(context),
                          child: const Text("More"),
                        ),
                      ],
                    )
                      : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/documents',
                              arguments: DocumentPageArguments(
                                widget.claim.claimNumber,
                                !widget.isEditable,
                              ),
                            );
                          },
                          child: const FaIcon(FontAwesomeIcons.fileLines),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/claim/details',
                                arguments: widget.claim,
                            );
                          },
                          child: const FaIcon(FontAwesomeIcons.circleInfo),
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
            widget.isEditable
              ? BlocProvider<CallCubit>(
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
                        claimNumber: widget.claim.claimNumber,
                        insuredContactNumber: widget.claim.insuredPerson.insuredContactNumber,
                      )) {
                        Navigator.pop(modalContext);
                      }
                    },
                  );
                },
              ),
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
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.fileLines,
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
          ],
        ),
      ),
    );
  }

  void _callListener(BuildContext context, CallState state) {
    if (state is CallLoading) {
      showSnackBar(context, AppStrings.connecting);
    } else if (state is CallReady) {
      showSnackBar(context, AppStrings.receiveCall, type: SnackBarType.success);
    } else if (state is CallFailed) {
      showSnackBar(context, state.cause, type: SnackBarType.error);
    }
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
    } else if (widget.videoRecorder!.caseClaimNumber != null &&
        widget.videoRecorder!.caseClaimNumber == widget.claim.claimNumber) {
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
