import 'dart:io';

import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wakelock/wakelock.dart';

import '../data/models/claim.dart';

class SoundRecorder {
  final Claim claim;

  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialized = false;

  bool get isRecording => _audioRecorder!.isRecording;

  SoundRecorder(this.claim);

  Future<void> init() async {
    _audioRecorder = FlutterSoundRecorder();
    await _audioRecorder!.openAudioSession();
    _isRecorderInitialized = true;
  }

  void dispose() {
    _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _isRecorderInitialized = false;
  }

  Future<void> _record() async {
    if (!_isRecorderInitialized) return;
    int _currentTime = DateTime.now().microsecondsSinceEpoch;
    Directory? directory = await getExternalStorageDirectory();
    Directory? _saveDirectory = await Directory(directory!.path + "/Audio").create();
    String _fileName = "/${claim.claimId}_$_currentTime.aac";
    await _audioRecorder!.startRecorder(toFile: _saveDirectory.path + _fileName, codec: Codec.aacADTS);
  }

  Future<File?> _stop() async {
    if (!_isRecorderInitialized) return null;
    String? _path = await _audioRecorder!.stopRecorder();
    return File(_path!);
  }

  Future<File?> toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      Wakelock.enable();
      await _record();
    } else {
      File? file = await _stop();
      Wakelock.disable();
      return file;
    }
    return null;
  }
}
