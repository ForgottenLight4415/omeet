import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omeet_motor/widgets/app_logo.dart';

import '../../blocs/otp_bloc/otp_cubit.dart';
import '../../utilities/show_snackbars.dart';
import '../../utilities/upload_dialog.dart';
import '../../widgets/input_fields.dart';

class VerificationView extends StatefulWidget {
  final String emailAddress;

  const VerificationView({Key? key, required this.emailAddress})
      : super(key: key);

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
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
                  listener: (context, state) {
                    if (state is OtpFailed) {
                      Navigator.pop(context);
                      showInfoSnackBar(context, state.cause, color: Colors.red);
                    } else if (state is OtpLoading) {
                      showProgressDialog(context,
                          label: "Verifying", content: "Verifying OTP...");
                    } else if (state is OtpSuccess) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/landing',
                        (route) => false,
                      );
                    }
                  },
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
                          child: Text("Not ${widget.emailAddress}?"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<OtpCubit>(context).verifyOtp(
                                widget.emailAddress, _controller.text);
                          },
                          child: const Text("VERIFY"),
                        )
                      ],
                    );
                  },
                )),
          ),
        ),
      ),
    );
  }
}
