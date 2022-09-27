import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omeet_motor/widgets/snack_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../data/repositories/call_repo.dart';
import '../utilities/screen_capture.dart';
import '../utilities/show_snackbars.dart';
import '../utilities/video_record_config.dart';
import 'input_fields.dart';
import 'scaling_tile.dart';
import 'phone_list_tile.dart';
import 'card_detail_text.dart';
import 'claim_options_tile.dart';
import '../data/models/claim.dart';
import '../utilities/app_constants.dart';
import '../utilities/screen_recorder.dart';
import '../blocs/call_bloc/call_cubit.dart';
import '../utilities/claim_option_functions.dart';
import '../utilities/app_permission_manager.dart';

class ClaimCard extends StatefulWidget {
  final Claim claim;
  final ScreenRecorder screenRecorder;
  final ScreenCapture screenCapture;
  final VideoRecorderConfig videoRecorderConfig;

  const ClaimCard({
    Key? key,
    required this.claim,
    required this.screenRecorder,
    required this.screenCapture,
    required this.videoRecorderConfig,
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
    return ScalingTile(
      onPressed: _openClaimMenu,
      child: Card(
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
                style: Theme.of(context).textTheme.headline3!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                  overflow: TextOverflow.fade,
                ),
              ),
              SizedBox(height: 10.h),
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      BlocProvider<CallCubit>(
                        create: (callContext) => CallCubit(),
                        child: BlocConsumer<CallCubit, CallState>(
                          listener: _callListener,
                          builder: (context, state) => ElevatedButton(
                            onPressed: () => _call(context),
                            child: const Icon(Icons.phone),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _videoCall(context),
                        child: const FaIcon(FontAwesomeIcons.video),
                      ),
                      ElevatedButton(
                        onPressed: () => _sendMessageModal(context, widget.claim.insuredContactNumber),
                        child: const Icon(Icons.mail),
                      ),
                      ElevatedButton(
                        onPressed: _openClaimMenu,
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

  Future<void> _sendMessageModal(BuildContext context, String? phoneNumber) async {
    final TextEditingController _controller = TextEditingController(text: phoneNumber ?? "");
    bool? _result = await showModalBottomSheet<bool?>(
      context: context,
      constraints: BoxConstraints(maxHeight: 200.h),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            CustomTextFormField(
              textEditingController: _controller,
              label: "Phone number",
              hintText: "Enter phone number",
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10.0),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  showInfoSnackBar(context, "Sending message", color: Colors.orange);
                },
                child: const Text("SEND"),
              ),
            ),
          ],
        ),
      ),
    );
    if (_result == null) {
      return;
    } else if (_controller.text.isNotEmpty || _controller.text.length != 10) {
      if (await CallRepository().sendMessage(
        claimNumber: widget.claim.claimNumber,
        phoneNumber: _controller.text,
      )) {
        showInfoSnackBar(context, "Message sent", color: Colors.green);
      } else {
        showInfoSnackBar(context, "Failed", color: Colors.red);
      }
    } else {
      showInfoSnackBar(context, "Enter a valid phone number", color: Colors.red);
    }
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

  Future<void> _videoCall(BuildContext context) async {
    bool cameraStatus = await cameraPermission();
    bool microphoneStatus = await microphonePermission();
    bool storageStatus = await storagePermission();
    if (cameraStatus && microphoneStatus && storageStatus) {
      Navigator.pushNamed(context, '/claim/meeting', arguments: widget.claim);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.camMicStoragePerm)),
      );
    }
  }

  Future<void> _call(BuildContext context) async {
    String? _selectedPhone;
    if (widget.claim.insuredAltContactNumber != AppStrings.unavailable) {
      _selectedPhone = await showModalBottomSheet(
        context: context,
        constraints: BoxConstraints(maxHeight: 300.h),
        builder: (context) => Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                AppStrings.voiceCall,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Divider(
              height: 0.5,
              thickness: 0.5,
              indent: 50.w,
              endIndent: 50.w,
              color: Colors.black54,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop<String>(
                  context,
                  widget.claim.insuredContactNumber,
                );
              },
              child: PhoneListTile(
                phoneNumber: widget.claim.insuredContactNumber,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop<String>(
                  context,
                  widget.claim.insuredAltContactNumber,
                );
              },
              child: PhoneListTile(
                phoneNumber: widget.claim.insuredAltContactNumber,
                primary: false,
              ),
            )
          ],
        ),
      );
    } else {
      _selectedPhone = widget.claim.insuredContactNumber;
    }
    if (_selectedPhone != null) {
      BlocProvider.of<CallCubit>(context).callClient(
        claimNumber: widget.claim.claimNumber,
        phoneNumber: _selectedPhone,
        customerName: widget.claim.insuredName,
      );
    }
  }

  void _openClaimMenu() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (modalContext) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.fileAlt,
              label: "Documents",
              onPressed: () {
                Navigator.pop(modalContext);
                Navigator.pushNamed(
                  context,
                  '/documents',
                  arguments: widget.claim.claimNumber,
                );
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
              faIcon: FontAwesomeIcons.camera,
              label: "Capture image",
              onPressed: () {
                Navigator.pop(modalContext);
                captureImage(context, widget.claim);
              },
            ),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.mobileAlt,
              label: _getScreenshotText(),
              onPressed: () async {
                Navigator.pop(modalContext);
                await handleScreenshotService(
                  context,
                  widget.screenCapture,
                  widget.claim.claimNumber,
                );
                _setCardColor();
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
                  widget.videoRecorderConfig,
                ).then((_) {
                  _setCardColor();
                });
              },
            ),
            ClaimPageTiles(
              faIcon: FontAwesomeIcons.video,
              label: "Video call",
              onPressed: () {
                Navigator.pop(modalContext);
                videoCall(context, widget.claim);
              },
            ),
            ClaimPageTiles(faIcon: FontAwesomeIcons.info, label: "Details", onPressed: () {
              Navigator.pop(modalContext);
              Navigator.pushNamed(context, '/claim/details', arguments: widget.claim);
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

  String _getScreenshotText() {
    if (widget.screenCapture.isServiceRunning) {
      if (widget.screenCapture.claimNumber != widget.claim.claimNumber) {
        return "Stop screenshot service for ${widget.screenCapture.claimNumber}";
      } else {
        return "Stop screenshot service";
      }
    }
    return "Start screenshot service";
  }

  void _setCardColor() async {
    _screenshotClaim = widget.screenCapture.claimNumber;
    if (widget.screenRecorder.isRecording) {
      setState(() {
        _cardColor = Colors.red.shade100;
      });
    } else if (_screenshotClaim != null &&
        _screenshotClaim == widget.claim.claimNumber) {
      setState(() {
        _cardColor = Colors.red.shade100;
      });
    } else if (widget.videoRecorderConfig.claimNumber != null
        && widget.videoRecorderConfig.claimNumber == widget.claim.claimNumber) {
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
