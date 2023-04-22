import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omeet_motor/data/models/document.dart';
import 'package:omeet_motor/views/documents/video_player.dart';
import 'package:omeet_motor/views/documents/videos_page.dart';
import 'package:omeet_motor/views/landing.dart';

import '../data/models/claim.dart';
import '../utilities/camera_utility.dart';
import '../views/auth/verification_view.dart';
import '../views/documents/audio_list_view.dart';
import '../views/documents/doc_viewer.dart';
import '../views/documents/documents_page.dart';
import '../views/auth/login_view.dart';
import '../views/claims/assigned_claims_view.dart';
import '../views/invalid_route.dart';
import '../views/meet_pages/details_page.dart';
import '../views/meet_pages/meet_main.dart';
import '../views/recorder_pages/audio_recorder_page.dart';
import '../views/recorder_pages/image_capture_page.dart';
import '../views/recorder_pages/video_recorder_page.dart';
import '../views/uploads_page.dart';

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

      case '/landing':
        return _platformDependentRouting(const LandingPage());

      // Claims
      case '/assigned':
        return _platformDependentRouting(const AssignedClaimsView());
      case '/claim/details':
        final Claim _claim = args as Claim;
        return _platformDependentRouting(
          DetailsPage(claim: _claim),
        );

      // MEETING ROUTES
      case '/claim/meeting':
        final Claim _claim = args as Claim;
        return _platformDependentRouting(MeetingMainPage(claim: _claim));

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
          AudioListView(
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
