import 'package:omeet_motor/utilities/screen_recorder.dart';
import 'package:omeet_motor/utilities/video_recorder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecorderInitialization {
  ScreenRecorder? _screenRecorder;
  VideoRecorder? _videoRecorder;

  RecorderInitialization._create() {
    _screenRecorder = ScreenRecorder();
  }

  static Future<RecorderInitialization> create() async {
    RecorderInitialization component = RecorderInitialization._create();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    component._videoRecorder = VideoRecorder(
        claimNumber: _pref.getString("video-recording-cn"),
    );
    return component;
  }

  ScreenRecorder? get screenRecorder {
    return _screenRecorder;
  }

  VideoRecorder? get videoRecorder {
    return _videoRecorder;
  }
}