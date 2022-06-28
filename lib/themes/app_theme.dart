import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  AppTheme._();

  static final BorderRadius _borderRadius = BorderRadius.circular(14.r);

  static final lightTheme = ThemeData(
    primarySwatch: Colors.red,
    scaffoldBackgroundColor: const Color(0xFFEFEFEF),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(14.r),
          topLeft: Radius.circular(14.r),
        ),
      ),
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 38.sp,
        fontWeight: FontWeight.w500,
      ),
      headline2: TextStyle(fontSize: 30.sp),
      headline3: TextStyle(fontSize: 28.sp),
      headline4: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w700),
      headline5: TextStyle(
        fontSize: 24.sp,
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
      headline6: TextStyle(fontSize: 22.sp),
      bodyText1: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400),
      bodyText2: TextStyle(fontSize: 18.sp),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.resolveWith(
          (states) => TextStyle(fontSize: 20.sp, color: Colors.white),
        ),
        padding: MaterialStateProperty.resolveWith(
          (states) => EdgeInsets.symmetric(vertical: 15.h, horizontal: 25.w),
        ),
        shape: MaterialStateProperty.resolveWith(
          (states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        elevation: MaterialStateProperty.resolveWith((states) => 5.0),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      border: UnderlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: BorderSide.none,
      ),
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: _borderRadius,
      ),
      elevation: 4.0,
    ),
  );
}
