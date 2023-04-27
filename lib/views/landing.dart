import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:omeet_motor/widgets/app_logo.dart';

import '../data/repositories/auth_repo.dart';
import '../widgets/landing_card.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           const AppLogo(),
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
                          Navigator.pushNamed(context, '/assigned');
                        },
                        fontAwesomeIcons: FontAwesomeIcons.listCheck,
                        label: "Assigned"),
                    LandingCard(
                      onPressed: () {
                        Navigator.pushNamed(context, '/uploads');
                      },
                      fontAwesomeIcons: FontAwesomeIcons.arrowUp,
                      label: "Uploads",
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
                      fontAwesomeIcons: FontAwesomeIcons.rightFromBracket,
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
                  "OMeet Health Audit\nVersion 1.1.8 (Build 76)",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
