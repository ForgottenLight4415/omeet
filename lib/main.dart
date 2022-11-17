import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omeet_motor/routes/routes.dart';
import 'package:omeet_motor/themes/app_theme.dart';
import 'package:omeet_motor/utilities/screen_capture.dart';
import 'package:omeet_motor/utilities/screen_recorder.dart';
import 'package:omeet_motor/utilities/video_record_config.dart';
import 'package:omeet_motor/views/claims/assigned_claims.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/auth_repo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool _isSignedIn = await AuthRepository().signIn();
  runApp(OMeetApp(isSignedIn: _isSignedIn));
}

class OMeetApp extends StatefulWidget {
  final bool isSignedIn;

  const OMeetApp({Key? key, required this.isSignedIn}) : super(key: key);

  @override
  State<OMeetApp> createState() => _OMeetAppState();
}

class _OMeetAppState extends State<OMeetApp> {
  ScreenRecorder? _screenRecorder;
  ScreenCapture? _screenCapture;
  VideoRecorderConfig? _videoRecorderConfig;

  void _initMediaRecorders() async {
    _screenRecorder = ScreenRecorder();
    _screenCapture = ScreenCapture();
    _videoRecorderConfig = VideoRecorderConfig();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String? videoRecordingClaimNumber = _pref.getString("video-recording-cn");
    if (videoRecordingClaimNumber != null) {
      _videoRecorderConfig!.claimNumber = videoRecordingClaimNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ScreenUtilInit(
      designSize: const Size(412, 915),
      builder: (BuildContext context, Widget? child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OMeet',
        theme: AppTheme.lightTheme,
        builder: (BuildContext? context, Widget? widget) {
          return MediaQuery(
            data: MediaQuery.of(context!).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
        onGenerateRoute: RouteGenerator.generateRoute,
        onGenerateInitialRoutes: (_) {
          _initMediaRecorders();
          if (widget.isSignedIn) {
            return [
              RouteGenerator.generateRoute(
                  RouteSettings(
                    name: '/landing',
                    arguments: RecorderObjects(
                      _screenCapture!,
                      _screenRecorder!,
                      _videoRecorderConfig!,
                    ),
                  ),
              ),
            ];
          } else {
            return [
              RouteGenerator.generateRoute(
                RouteSettings(
                  name: '/login',
                  arguments: RecorderObjects(
                    _screenCapture!,
                    _screenRecorder!,
                    _videoRecorderConfig!,
                  ),
                ),
              ),
            ];
          }
        },
        scrollBehavior: const ScrollBehavior().copyWith(
          physics: const BouncingScrollPhysics(),
        ),
      ),
    );
  }
}
