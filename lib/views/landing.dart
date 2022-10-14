import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../blocs/call_bloc/call_cubit.dart';
import '../data/repositories/auth_repo.dart';
import '../utilities/app_constants.dart';
import '../utilities/images.dart';
import '../views/claims/assigned_claims.dart';
import '../widgets/input_fields.dart';
import '../widgets/landing_card.dart';
import '../widgets/snack_bar.dart';

class LandingPage extends StatelessWidget {
  final RecorderObjects objects;

  const LandingPage({Key? key, required this.objects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 45.0),
            child: Image.asset(
              Images.appLogo,
              height: 170.w,
              width: 170.w,
            ),
          ),
          Text(
            AppStrings.appName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3!.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 400.h,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                children: <Widget>[
                  LandingCard(
                      onPressed: () {
                        Navigator.pushNamed(context, '/new/claim');
                      },
                      fontAwesomeIcons: FontAwesomeIcons.plus,
                      label: "Create\nClaim"),
                  LandingCard(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/assigned',
                          arguments: objects,
                        );
                      },
                      fontAwesomeIcons: FontAwesomeIcons.tasks,
                      label: "Assigned Claims"),
                  LandingCard(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/self-assign',
                        );
                      },
                      fontAwesomeIcons: FontAwesomeIcons.tasks,
                      label: "Assign\nto self",
                  ),
                  BlocProvider<CallCubit>(
                    create: (callContext) => CallCubit(),
                    child: BlocConsumer<CallCubit, CallState>(
                      listener: _callListener,
                      builder: (callContext, state) => LandingCard(
                        onPressed: () async {
                          await customCallSetup(callContext);
                        },
                        fontAwesomeIcons: FontAwesomeIcons.phoneAlt,
                        label: "Custom calls",
                      ),
                    ),
                  ),
                  LandingCard(
                    onPressed: () {
                      Navigator.pushNamed(context, '/uploads');
                    },
                    fontAwesomeIcons: FontAwesomeIcons.upload,
                    label: "Pending Uploads",
                  ),
                  LandingCard(
                    onPressed: () async {
                      await AuthRepository().signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                          arguments: objects,
                      );
                    },
                    fontAwesomeIcons: FontAwesomeIcons.signOutAlt,
                    label: "Sign out",
                  ),
                ],
              ),
            ),
          )
        ],
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

  Future<void> customCallSetup(BuildContext context) async {
    final TextEditingController _claimNumberController = TextEditingController();
    final TextEditingController _managerPhoneController = TextEditingController();
    final TextEditingController _customerPhoneController = TextEditingController();

    final GlobalKey<FormState> _key = GlobalKey<FormState>();

    bool? result = await showModalBottomSheet<bool?>(
      context: context,
      constraints: BoxConstraints(maxHeight: 400.h),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _key,
          child: Column(
            children: <Widget>[
              CustomTextFormField(
                textEditingController: _claimNumberController,
                label: "Claim number",
                hintText: "Enter claim number",
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5.0),
              CustomTextFormField(
                textEditingController: _managerPhoneController,
                label: "Manager phone number",
                hintText: "Enter phone number",
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Required";
                  } else if (value.length != 10 || !value.contains(RegExp(r'^[0-9]+$'))) {
                    return "Enter a valid phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5.0),
              CustomTextFormField(
                textEditingController: _customerPhoneController,
                label: "Customer phone number",
                hintText: "Enter phone number",
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Required";
                  } else if (value.length != 10 || !value.contains(RegExp(r'^[0-9]+$'))) {
                    return "Enter a valid phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5.0),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      Navigator.pop(context, true);
                    }
                  },
                  child: const Text("Set call"),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (result != null && result) {
      BlocProvider.of<CallCubit>(context).callClient(
        claimNumber: _claimNumberController.text,
        phoneNumber: _managerPhoneController.text,
        customerName: _customerPhoneController.text,
      );
    }
  }
}
