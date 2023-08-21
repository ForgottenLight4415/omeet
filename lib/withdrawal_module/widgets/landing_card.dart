import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'base_card.dart';

class LandingCard extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData fontAwesomeIcons;
  final String label;

  const LandingCard(
      {Key? key,
        required this.onPressed,
        required this.fontAwesomeIcons,
        required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      onPressed: onPressed,
      card: Card(
        color: Colors.redAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FaIcon(
              fontAwesomeIcons,
              color: Colors.white,
              size: 36.sp,
            ),
            SizedBox(height: 12.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}