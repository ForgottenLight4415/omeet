import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utilities/images.dart';
import '../utilities/app_constants.dart';

class AppLogo extends StatelessWidget {
  final double? size;

  const AppLogo({Key? key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: size == null
              ? const EdgeInsets.symmetric(vertical: 45.0)
              : EdgeInsets.zero,
          child: Image.asset(Images.appLogo, height: size ?? 170.w, width: size ?? 170.w),
        ),
        size == null ? Text(
          AppStrings.appName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ) : const SizedBox(),
        size == null
          ? SizedBox(height: 20.h)
          : const SizedBox(),
      ],
    );
  }
}
