import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../blocs/call_bloc/call_cubit.dart';
import '../utilities/bridge_call.dart';
import '../views/claims/claims_view.dart';
import '../data/repositories/auth_repo.dart';
import '../utilities/app_constants.dart';
import '../widgets/omeet_drawer_header.dart';
import '../widgets/snack_bar.dart';

class ModernLandingPage extends StatelessWidget {
  final String email;
  final String phone;

  ModernLandingPage({Key? key, required this.email, required this.phone})
      : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cases'),
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.menu),
        ),
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            OMeetUserDrawerHeader(email: email, phone: phone),
            BlocProvider<CallCubit>(
              create: (context) => CallCubit(),
              child: BlocConsumer<CallCubit, CallState>(
                listener: _callListener,
                builder: (context, state) => ListTile(
                  leading: const FaIcon(
                    FontAwesomeIcons.phone,
                    color: Colors.red,
                  ),
                  title: const Text(
                    AppStrings.customCall,
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () async {
                    _scaffoldKey.currentState?.closeDrawer();
                    await customCallSetup(context);
                  },
                ),
              ),
            ),
            ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.arrowUp,
                color: Colors.red,
              ),
              title: const Text(
                AppStrings.uploads,
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/uploads');
              },
            ),
            Expanded(child: Container()),
            ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.arrowRightFromBracket,
                color: Colors.red,
              ),
              title: const Text(
                AppStrings.signOut,
                style: TextStyle(fontSize: 20),
              ),
              onTap: () async {
                await AuthRepository().signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/login',
                      (route) => false,
                );
              },
            ),
            const SizedBox(height: 5),
            const Align(
              alignment: Alignment.center,
              child: Text(
                AppStrings.appVersion,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black45
                ),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
      body: const ClaimsView(forSelfAssignment: false),
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