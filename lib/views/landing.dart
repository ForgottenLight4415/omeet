import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../blocs/call_bloc/call_cubit.dart';
import '../data/repositories/auth_repo.dart';
import '../utilities/app_constants.dart';
import '../utilities/bridge_call.dart';
import '../utilities/images.dart';
import '../widgets/landing_card.dart';
import '../widgets/snack_bar.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 60.h),
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
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
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
                        Navigator.pushNamed(context, '/assigned');
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
                    create: (context) => CallCubit(),
                    child: BlocConsumer<CallCubit, CallState>(
                      listener: _callListener,
                      builder: (context, state) => LandingCard(
                        onPressed: () async {
                          await customCallSetup(context);
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
                      );
                    },
                    fontAwesomeIcons: FontAwesomeIcons.signOutAlt,
                    label: "Sign out",
                  ),
                ],
              ),
            ),
          ),
          const Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "BAGIC MCI\nVersion 1.1.2 (Build 70)",
                textAlign: TextAlign.center,
              ),
            ),
          ),
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
}
