import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../blocs/otp_bloc/otp_cubit.dart';
import '../utilities/show_snackbars.dart';
import '../utilities/upload_dialog.dart';
import '../widgets/input_fields.dart';

class OtpPage extends StatefulWidget {
  final String email;

  const OtpPage({Key? key, required this.email}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider<OtpCubit>(
            create: (context) => OtpCubit(),
            child: BlocConsumer<OtpCubit, OtpState>(
              listener: (context, state) {
                if (state is OtpFailed) {
                  showInfoSnackBar(context, state.cause, color: Colors.red);
                } else if (state is OtpLoading) {
                  showProgressDialog(context,
                      label: "Verifying", content: "Verifying OTP...");
                } else if (state is OtpSuccess) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 45.0),
                      child: Image.asset(
                        "images/logo.png",
                        height: 170.w,
                        width: 170.w,
                      ),
                    ),
                    CustomTextFormField(
                      textEditingController: _controller,
                      label: "OTP",
                      hintText: "Enter OTP",
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Not ${widget.email}?"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<OtpCubit>(context)
                            .verifyOtp(widget.email, _controller.text);
                      },
                      child: const Text("VERIFY"),
                    )
                  ],
                );
              },
            )),
      ),
    );
  }
}
