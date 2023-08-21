import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CaseHeader extends StatelessWidget {
  final String noCases;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const CaseHeader({
    Key? key,
    required this.noCases,
    required this.label,
    required this.onPressed,
    this.isActive = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: isActive ? ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).primaryColor.withAlpha(40)),
      ) : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            noCases,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp
            ),
          ),
        ],
      ),
    );
  }
}
