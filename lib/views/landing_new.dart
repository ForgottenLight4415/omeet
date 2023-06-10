import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../blocs/call_bloc/call_cubit.dart';
import '../data/repositories/auth_repo.dart';
import '../utilities/app_constants.dart';
import '../utilities/bridge_call.dart';
import '../widgets/omeet_drawer_header.dart';
import '../widgets/snack_bar.dart';
import 'claims/claims_view.dart';

class ModernLandingPage extends StatelessWidget {
  final String email;
  final String phone;

  ModernLandingPage({Key? key, required this.email, required this.phone})
      : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Claims'),
            leading: IconButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              icon: const Icon(Icons.menu),
            ),
            bottom: const TabBar(
                labelColor: Colors.black,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.black),
                ),
                tabs: [
                  Tab(text: "Assigned"),
                  Tab(text: "Self assign"),
                ]),
            elevation: 1,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.pushNamed(context, "/new/claim"),
            icon: const Icon(Icons.add),
            label: const Text("Create claim")
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
          body: const TabBarView(
            children: [
              ClaimsView(),
              ClaimsView(forSelfAssignment: true),
            ],
          )),
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
