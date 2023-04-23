import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './scaling_tile.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  const PrimaryButton({Key? key, required this.onPressed, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ButtonStyle(
        shape: MaterialStateProperty.resolveWith(
          (states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        textStyle: MaterialStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w300,
          ),
        ),
        padding: MaterialStateProperty.resolveWith(
          (states) => EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 15.h,
          ),
        ),
      ),
    );
  }
}

class VideoMeetToggleButton extends StatelessWidget {
  final bool toggleParameter;
  final IconData primaryFaIcon;
  final IconData secondaryFaIcon;
  final VoidCallback onPressed;

  const VideoMeetToggleButton(
      {Key? key, required this.toggleParameter, required this.primaryFaIcon, required this.secondaryFaIcon, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScalingTile(
      onPressed: onPressed,
      child: SizedBox(
        height: 80.h,
        width: 80.h,
        child: Card(
          color: toggleParameter ? Colors.red : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(40.0),
          ),
          child: Center(
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: toggleParameter ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: FaIcon(
                primaryFaIcon,
                color: Colors.white,
              ),
              secondChild: FaIcon(
                secondaryFaIcon,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AppBackButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () {
        Navigator.pop(context);
      },
      icon: const Icon(CupertinoIcons.back),
    );
  }
}
