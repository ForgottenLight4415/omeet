import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omeet_motor/routes/routes.dart';
import 'package:omeet_motor/themes/app_theme.dart';

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
          if (widget.isSignedIn) {
            return [
              RouteGenerator.generateRoute(
                  const RouteSettings(name: '/landing'),
              ),
            ];
          } else {
            return [
              RouteGenerator.generateRoute(
                const RouteSettings(name: '/login'),
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
