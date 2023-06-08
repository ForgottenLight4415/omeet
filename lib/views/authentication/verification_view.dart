import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth_bloc/verification_bloc/verification_cubit.dart';
import '../../data/repositories/auth_repo.dart';
import '../../utilities/show_snackbars.dart';
import '../../utilities/upload_dialog.dart';
import '../../widgets/app_logo.dart';
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
            child: BlocProvider<VerificationCubit>(
                create: (context) => VerificationCubit(),
                child: BlocConsumer<VerificationCubit, VerificationState>(
                  listener: (context, state) async {
                    if (state is VerificationFailed) {
                      showInfoSnackBar(context, state.cause, color: Colors.red);
                    } else if (state is VerificationVerifying) {
                      showProgressDialog(context,
                          label: "Verifying", content: "Verifying OTP...");
                    } else if (state is VerificationSuccess) {
                      List<String?>? userDetails =
                      await AuthRepository().getUserDetails();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/new_landing', (route) => false,
                          arguments: userDetails);
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
                            BlocProvider.of<VerificationCubit>(context).verifyOtp(
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
