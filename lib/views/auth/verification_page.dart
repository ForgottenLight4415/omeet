import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omeet_motor/blocs/otp_bloc/otp_cubit.dart';

import '../../data/repositories/auth_repo.dart';
import '../../utilities/show_snackbars.dart';
import '../../utilities/upload_dialog.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/input_fields.dart';

class VerificationView extends StatefulWidget {
  final List<String> loginDetails;

  const VerificationView({Key? key, required this.loginDetails})
      : super(key: key);

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  late final bool development;
  final TextEditingController _controller = TextEditingController();

  bool _isButtonEnabled = false; // Enable the button initially
  bool _isTimerRunning = false; // Track the timer state

  Timer? _timer;
  int _countdownSeconds = 120;

  void _startTimer() {
    _countdownSeconds = 120;
    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
          if (_countdownSeconds == 0) {
            _isButtonEnabled = true;  // Enable the button after 120 seconds
          }
        } else {
          timer.cancel();
          _isTimerRunning = false;
        }
      });
    });
  }

  void _resendOtpCallback(BuildContext context) {
    if (!_isTimerRunning) {
      setState(() {
        _isButtonEnabled = false;
      });
      _startTimer();
    }
    BlocProvider.of<OtpCubit>(context)
        .resendOtp(
      widget.loginDetails[0],
      widget.loginDetails[1],
    );
  }


  @override
  void initState() {
    super.initState();
    // TODO: DEVELOPMENT FLAG
    development = false;
    _startTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocProvider<OtpCubit>(
                create: (context) => OtpCubit(),
                child: BlocConsumer<OtpCubit, OtpState>(
                  listener: _otpCubitListener,
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const AppLogo(),
                        CustomTextFormField(
                          textEditingController: _controller,
                          label: "OTP",
                          hintText: "Enter OTP",
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Not ${widget.loginDetails[0]}?"),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<OtpCubit>(context).verifyOtp(
                                  widget.loginDetails[0],
                                  _controller.text,
                                  development
                                );
                              },
                              child: const Text("VERIFY"),
                            ),
                            ElevatedButton(
                              onPressed: _isButtonEnabled
                                  ? () => _resendOtpCallback(context)
                                  : null,
                              style: Theme.of(context)
                                  .elevatedButtonTheme
                                  .style
                                  ?.copyWith(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                      (states) => _isButtonEnabled
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                  ),
                              child: const Text("RESEND OTP"),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24.0),
                        _isButtonEnabled
                          ? const SizedBox()
                          : Text("RESEND OTP IN $_countdownSeconds SECONDS"),
                      ],
                    );
                  },
                )),
          ),
        ),
      ),
    );
  }

  void _otpCubitListener(BuildContext context, OtpState state) async {
    if (state is RequestingNewOtp) {
      showInfoSnackBar(
        context,
        "Requesting new OTP",
        color: Colors.orange,
      );
    } else if (state is RequestedNewOtp) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      showInfoSnackBar(
        context,
        "OTP sent to ${widget.loginDetails[1]}",
        color: Colors.green,
      );
    } else if (state is RequestOtpFailure) {
      showInfoSnackBar(
        context,
        "Failed to request a new OTP",
        color: Colors.red,
      );
    } else if (state is OtpSuccess) {
      List<String?>? userDetails = await AuthRepository().getUserDetails();
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/new_landing_b',
        (route) => false,
        arguments: userDetails,
      );
    } else if (state is OtpVerificationFailureState) {
      Navigator.pop(context);
      showInfoSnackBar(context, state.cause, color: Colors.red);
    } else if (state is OtpLoading) {
      showProgressDialog(context, label: "Verify OTP", content: "Please wait");
    }
  }
}
