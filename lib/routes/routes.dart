import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omeet_motor/data/models/document.dart';
import 'package:omeet_motor/views/call_conclusion.dart';
import 'package:omeet_motor/views/documents/video_player.dart';
import 'package:omeet_motor/views/documents/videos_page.dart';
import 'package:omeet_motor/views/landing_new_b.dart';
import 'package:omeet_motor/withdrawal_module/data/models/withdrawal.dart';
import 'package:omeet_motor/withdrawal_module/landing.dart';

import '../data/models/claim.dart';
import '../utilities/camera_utility.dart';
import '../views/auth/verification_page.dart';
import '../views/conclusion_page_main.dart';
import '../views/documents/audio_page.dart';
import '../views/documents/doc_viewer.dart';
import '../views/documents/documents_page.dart';
import '../views/auth/login.dart';
import '../views/invalid_route.dart';
import '../views/meet_pages/details_page.dart';
import '../views/meet_pages/meet_main.dart';
import '../views/recorder_pages/audio_recorder_page.dart';
import '../views/recorder_pages/image_capture_page.dart';
import '../views/recorder_pages/video_recorder_page.dart';
import '../views/uploads_page.dart';

import '../withdrawal_module/views/meet_pages/details_page.dart' as dp;
import '../withdrawal_module/data/models/document.dart' as doc;
import '../withdrawal_module/views/documents/documents_page.dart' as doc_page;
import '../withdrawal_module/views/documents/videos_page.dart' as vid_page;
import '../withdrawal_module/views/documents/audio_page.dart' as aud_page;
import '../withdrawal_module/views/meet_pages/meet_main.dart' as meet_main;
import '../withdrawal_module/views/recorder_pages/video_recorder_page.dart' as video_rec;
import '../withdrawal_module/views/recorder_pages/image_capture_page.dart' as image_cap;
import '../withdrawal_module/views/recorder_pages/audio_recorder_page.dart' as audio_rec;
import '../withdrawal_module/utilities/camera_utility.dart' as cam_util;

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // AUTH
      case '/login':
        return _platformDependentRouting(const LoginView());
      case '/otp':
        final List<String> loginDetails = args as List<String>;
        return _platformDependentRouting(
          VerificationView(loginDetails: loginDetails),
        );

      case '/new_landing_b':
        final List<String?>? userDetails = args as List<String?>?;
        return _platformDependentRouting(
          LandingNewB(
            email: userDetails?[0] ?? "Unavailable",
            phone: userDetails?[1] ?? "Unavailable",
          ),
        );

      case '/withdrawal/landing':
        final List<String?>? userDetails = args as List<String?>?;
        return _platformDependentRouting(
          WithdrawalLanding(
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

      case '/withdrawal/claim/details':
        final Withdrawal _claim = args as Withdrawal;
        return _platformDependentRouting(
          dp.DetailsPage(claim: _claim),
        );

      // MEETING ROUTES
      case '/claim/meeting':
        final Claim _claim = args as Claim;
        return _platformDependentRouting(MeetingMainPage(claim: _claim));

      case 'withdrawal/claim/meeting':
        final Withdrawal _claim = args as Withdrawal;
        return _platformDependentRouting(meet_main.MeetingMainPage(claim: _claim));

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

      case 'withdrawal/record/audio':
        final audio_rec.AudioRecordArguments _audioRecArguments =
        args as audio_rec.AudioRecordArguments;
        return _platformDependentRouting(
            audio_rec.AudioRecordPage(arguments: _audioRecArguments));
      case 'withdrawal/record/video':
        final video_rec.VideoPageConfig _videoRecArgs = args as video_rec.VideoPageConfig;
        return _platformDependentRouting(
          video_rec.VideoRecordPage(config: _videoRecArgs),
        );
      case 'withdrawal/capture/image':
        final cam_util.CameraCaptureArguments _captureImageArgs =
        args as cam_util.CameraCaptureArguments;
        return _platformDependentRouting(
          image_cap.CaptureImagePage(arguments: _captureImageArgs),
        );

      // DOCUMENT ROUTES
      case '/uploads':
        return _platformDependentRouting(const UploadsPage());
      case '/documents':
        final DocumentPageArguments _arguments = args as DocumentPageArguments;
        return _platformDependentRouting(
          DocumentsPage(
            caseId: _arguments.claimNumber,
            readOnly: _arguments.readOnly,
          ),
        );

      case '/withdrawal/documents':
        final doc.DocumentPageArguments _arguments = args as doc.DocumentPageArguments;
        return _platformDependentRouting(
          doc_page.DocumentsPage(
            caseId: _arguments.claimNumber,
            readOnly: _arguments.readOnly,
          ),
        );

      case '/videos':
        final DocumentPageArguments _arguments = args as DocumentPageArguments;
        return _platformDependentRouting(
          VideosPage(
            caseId: _arguments.claimNumber,
            readOnly: _arguments.readOnly,
          ),
        );

      case '/withdrawal/videos':
        final doc.DocumentPageArguments _arguments = args as doc.DocumentPageArguments;
        return _platformDependentRouting(
          vid_page.VideosPage(
            caseId: _arguments.claimNumber,
            readOnly: _arguments.readOnly,
          ),
        );

      case '/audio':
        final DocumentPageArguments _arguments = args as DocumentPageArguments;
        return _platformDependentRouting(
          AudioPage(
            caseId: _arguments.claimNumber,
            readOnly: _arguments.readOnly,
          ),
        );

      case '/withdrawal/audio':
        final doc.DocumentPageArguments _arguments = args as doc.DocumentPageArguments;
        return _platformDependentRouting(
          aud_page.AudioPage(
            caseId: _arguments.claimNumber,
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
        final VideoWebViewArguments _args = args as VideoWebViewArguments;
        return _platformDependentRouting(VideoWebView(arguments: _args));

      case '/call_conclusion':
        final List<String> _args = args as List<String>;
        return _platformDependentRouting(CallConclusionPage(
          managerPhoneNumber: _args[0],
          customerPhoneNumber: _args[1],
          caseId: _args[2],
        ));

      case '/final_conclusion':
        final Claim _args = args as Claim;
        return _platformDependentRouting(ConclusionPageMain(claim: _args));

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
