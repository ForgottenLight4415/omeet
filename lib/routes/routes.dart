import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/models/claim.dart';
import '../utilities/camera_utility.dart';
import '../views/create_claim_page.dart';
import '../views/doc_viewer.dart';
import '../views/documents_page.dart';
import '../views/login.dart';
import '../views/home.dart';
import '../views/invalid_route.dart';
import '../views/meet_pages/meet_main.dart';
import '../views/otp_page.dart';
import '../views/recorder_pages/audio_record.dart';
import '../views/recorder_pages/image_capture.dart';
import '../views/recorder_pages/video_record.dart';
import '../views/uploads_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return _platformDependentRouting(const HomePage());
      case '/login':
        return _platformDependentRouting(const SignInPage());
      case '/otp':
        final String email = args as String;
        return _platformDependentRouting(OtpPage(email: email));

    // MEETING ROUTES
      case '/claim/meeting':
        final Claim _claim = args as Claim;
        return _platformDependentRouting(MeetingMainPage(claim: _claim));

    // RECORDER ROUTES
      case '/record/audio':
        final AudioRecordArguments _audioRecArguments = args as AudioRecordArguments;
        return _platformDependentRouting(AudioRecordPage(arguments: _audioRecArguments));
      case '/record/video':
        final VideoPageConfig _videoRecArgs = args as VideoPageConfig;
        return _platformDependentRouting(
          VideoRecordPage(config: _videoRecArgs),
        );
      case '/capture/image':
        final CameraCaptureArguments _captureImageArgs = args as CameraCaptureArguments;
        return _platformDependentRouting(
          CaptureImagePage(arguments: _captureImageArgs),
        );

      case '/uploads':
        return _platformDependentRouting(const UploadsPage());

      case '/documents':
        final String _claimNumber = args as String;
        return _platformDependentRouting(DocumentsPage(claimNumber: _claimNumber));
      case '/view/document':
        final String _documentUrl = args as String;
        return _platformDependentRouting(DocumentViewPage(documentUrl: _documentUrl));

      case '/new/claim':
        return _platformDependentRouting(const NewClaimPage());

      default:
        return _platformDependentRouting(const InvalidRoute());
    }
  }

  static Route<dynamic> _platformDependentRouting<T>(Widget widget) {
    if (Platform.isAndroid) {
      return MaterialPageRoute<T>(
        builder: (context) => widget,
      );
    } else {
      return CupertinoPageRoute<T>(
        builder: (context) => widget,
      );
    }
  }
}
