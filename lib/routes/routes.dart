import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omeet_motor/views/landing_new.dart';

import '../data/models/claim.dart';
import '../data/models/document.dart';

import '../utilities/camera_utility.dart';
import '../views/authentication/login_view.dart';
import '../views/authentication/verification_view.dart';
import '../views/documents/audio_page.dart';
import '../views/documents/video_player.dart';
import '../views/documents/videos_page.dart';
import '../views/recorder_pages/audio_recorder_page.dart';
import '../views/recorder_pages/image_capture_page.dart';
import '../views/recorder_pages/video_recorder_page.dart';
import '../views/uploads_view.dart';

import '../views/documents/documents_list_view.dart';
import '../views/documents/doc_viewer.dart';

import '../views/meet_pages/meet_main.dart';
import '../views/claims/details_view.dart';

import '../views/invalid_route.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // AUTH
      case '/login':
        return _platformDependentRouting(const LoginView());
      case '/otp':
        final String email = args as String;
        return _platformDependentRouting(
          VerificationView(emailAddress: email),
        );

      case '/new_landing':
        final List<String?>? userDetails = args as List<String?>?;
        return _platformDependentRouting(
          ModernLandingPage(
            email: userDetails?[0] ?? "Unavailable",
            phone: userDetails?[1] ?? "Unavailable",
          ),
        );

      // Claims
      case '/claim/details':
        final Claim _claim = args as Claim;
        return _platformDependentRouting(
          DetailsPage(claim: _claim),
        );

      // RECORDER ROUTES
      case '/record/audio':
        final AudioRecordArguments _audioRecArguments =
            args as AudioRecordArguments;
        return _platformDependentRouting(
            AudioRecordPage(arguments: _audioRecArguments));
      case '/record/video':
        final VideoPageConfig _videoRecArgs = args as VideoPageConfig;
        return _platformDependentRouting(
          VideoRecordPage(config: _videoRecArgs),
        );
      case '/capture/image':
        final CameraCaptureArguments _captureImageArgs =
            args as CameraCaptureArguments;
        return _platformDependentRouting(
          CaptureImagePage(arguments: _captureImageArgs),
        );

      // MEETING ROUTES
      case '/claim/meeting':
        final Claim _claim = args as Claim;
        return _platformDependentRouting(MeetingMainPage(claim: _claim));

      // DOCUMENT ROUTES
      case '/uploads':
        return _platformDependentRouting(const UploadsPage());
      case '/documents':
        final DocumentPageArguments _arguments = args as DocumentPageArguments;
        return _platformDependentRouting(
          DocumentsPage(
            claimNumber: _arguments.claimNumber,
            readOnly: _arguments.readOnly,
          ),
        );
      case '/view/document':
        final DocumentViewPageArguments _documentArguments =
            args as DocumentViewPageArguments;
        return _platformDependentRouting(
          DocumentViewPage(
            documentUrl: _documentArguments.documentUrl,
            type: _documentArguments.type,
          ),
        );
      case '/videos':
        final DocumentPageArguments _arguments = args as DocumentPageArguments;
        return _platformDependentRouting(
          VideosPage(
            claimNumber: _arguments.claimNumber,
            readOnly: _arguments.readOnly,
          ),
        );
      case '/audio':
        final DocumentPageArguments _arguments = args as DocumentPageArguments;
        return _platformDependentRouting(
          AudioPage(
            claimNumber: _arguments.claimNumber,
            readOnly: _arguments.readOnly,
          ),
        );

      case '/view/audio-video':
        final String _pageUrl = args as String;
        return _platformDependentRouting(VideoWebView(pageUrl: _pageUrl));

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
