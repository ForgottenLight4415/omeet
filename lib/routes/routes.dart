import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omeet_motor/views/claims/hospital_claims_view.dart';
import 'package:omeet_motor/views/claims/update_claim.dart';

import '../data/models/audit.dart';
import '../utilities/camera_utility.dart';
import '../views/auth/verification_view.dart';
import '../views/documents/audio_list_view.dart';
import '../views/documents/doc_viewer.dart';
import '../views/documents/documents_list_view.dart';
import '../views/auth/login_view.dart';
import '../views/invalid_route.dart';
import '../views/claims/details_view.dart';
import '../views/landing_new.dart';
import '../views/meeting_views/meet_main.dart';
import '../views/recorder_views/audio_recorder_view.dart';
import '../views/recorder_views/image_capture_view.dart';
import '../views/recorder_views/video_recorder_view.dart';
import '../views/uploads_page.dart';
import '../views/documents/video_player.dart';
import '../views/documents/videos_list_view.dart';
import '../views/landing.dart';

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

      case '/new_landing':
        final List<String?>? userDetails = args as List<String?>?;
        return _platformDependentRouting(
          ModernLandingPage(
            email: userDetails?[0] ?? "Unavailable",
            phone: userDetails?[1] ?? "Unavailable",
          ),
        );

      // Claims
      case '/hospital/claims':
        final String hospitalId = args as String;
        return _platformDependentRouting(
          HospitalClaimsView(
            hospitalId: hospitalId,
          ),
        );
      case '/claim/details':
        final Audit _claim = args as Audit;
        return _platformDependentRouting(
          DetailsView(claim: _claim),
        );

      // MEETING ROUTES
      case '/claim/meeting':
        final Audit _claim = args as Audit;
        return _platformDependentRouting(MeetingMainPage(claim: _claim));

      // RECORDER ROUTES
      case '/record/audio':
        final AudioRecordArguments _audioRecArguments =
            args as AudioRecordArguments;
        return _platformDependentRouting(
            AudioRecordView(arguments: _audioRecArguments));
      case '/record/video':
        final VideoPageConfig _videoRecArgs = args as VideoPageConfig;
        return _platformDependentRouting(
          VideoRecordView(config: _videoRecArgs),
        );
      case '/capture/image':
        final CameraCaptureArguments _captureImageArgs =
            args as CameraCaptureArguments;
        return _platformDependentRouting(
          CaptureImageView(arguments: _captureImageArgs),
        );

      // DOCUMENT ROUTES
      case '/uploads':
        return _platformDependentRouting(const UploadsPage());
      case '/update':
        final String hospitalId = args as String;
        return _platformDependentRouting(UpdateClaim(hospitalId: hospitalId));

      case '/documents':
        final String _arguments = args as String;
        return _platformDependentRouting(
          DocumentsListView(claimNumber: _arguments),
        );
      case '/videos':
        final String _arguments = args as String;
        return _platformDependentRouting(
          VideosListView(claimNumber: _arguments),
        );
      case '/audio':
        final String _arguments = args as String;
        return _platformDependentRouting(
          AudioListView(claimNumber: _arguments),
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
