import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../utilities/app_constants.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorText;
  final String actionLabel;
  final VoidCallback action;

  const CustomErrorWidget({
    Key? key,
    required this.errorText,
    required this.action,
    this.actionLabel = AppStrings.retry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            AppStrings.errorImage,
            height: 400.h,
            width: 500.w,
          ),
          _ErrorText(errorText: errorText),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: action,
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

class InformationWidget extends StatelessWidget {
  final String svgImage;
  final String label;

  const InformationWidget({
    Key? key,
    required this.svgImage,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(svgImage, height: 300.h, width: 150.w),
          const SizedBox(height: 30),
          Text(
            label,
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontFamily: AppStrings.secondaryFontFam,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
          ),
        ],
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  final String errorText;

  const _ErrorText({Key? key, required this.errorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      errorText,
      textAlign: TextAlign.center,
      maxLines: 3,
      style: Theme.of(context).textTheme.bodyText1!.copyWith(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
    );
  }
}
