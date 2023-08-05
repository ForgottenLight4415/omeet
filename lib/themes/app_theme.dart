import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class AppTheme {
  AppTheme._();

  static const MaterialColor themeColor = MaterialColor(
    _primaryShade,
    <int, Color>{
      50: Color(0xFFF3BC8B),
      100: Color(0xFFF1AE74),
      200: Color(0xFFEEA15D),
      300: Color(0xFFEC9345),
      400: Color(0xFFE9862E),
      500: Color(_primaryShade),
      600: Color(0xFFD06C15),
      700: Color(0xFFB96012),
      800: Color(0xFFA25410),
      900: Color(0xFF8B480E),
    },
  );
  static const int _primaryShade = 0xFFE77817;

  static final BorderRadius _borderRadius = BorderRadius.circular(24.r);

  static final lightTheme = ThemeData(
    primarySwatch: themeColor,
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
        elevation: 0
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
        displayLarge: TextStyle(
          fontSize: 38.sp,
          fontWeight: FontWeight.w500,
        ),
        displayMedium: TextStyle(fontSize: 30.sp),
        displaySmall: TextStyle(fontSize: 28.sp),
        headlineMedium: TextStyle(
          color: const Color(_primaryShade),
          fontSize: 26.sp,
          fontWeight: FontWeight.w700,
          overflow: TextOverflow.fade,
        ),
        headlineSmall: TextStyle(fontSize: 24.sp),
        titleLarge: TextStyle(fontSize: 22.sp),
        bodyLarge: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontSize: 18.sp),
        bodySmall: TextStyle(fontSize: 16.sp)
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.resolveWith(
              (states) => TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        padding: MaterialStateProperty.resolveWith(
              (states) => EdgeInsets.symmetric(vertical: 12.h, horizontal: 32.w),
        ),
        shape: MaterialStateProperty.resolveWith(
              (states) => RoundedRectangleBorder(borderRadius: _borderRadius),
        ),
        elevation: MaterialStateProperty.resolveWith((states) => 3.0),
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
      elevation: 3.0,
    ),
  );
}
