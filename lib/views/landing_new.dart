import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../views/claims/claims_view_new.dart';
import '../data/repositories/auth_repo.dart';
import '../utilities/app_constants.dart';
import '../widgets/omeet_drawer_header.dart';

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
          title: const Text('Claims'),
          leading: IconButton(
            onPressed: _scaffoldKey.currentState?.openDrawer,
            icon: const Icon(Icons.menu),
          ),
        ),
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              OMeetUserDrawerHeader(email: email, phone: phone),
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
        body: const ClaimsView(isCompleted: false),
    );
  }
}