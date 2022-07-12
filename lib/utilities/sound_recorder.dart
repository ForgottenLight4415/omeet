import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rc_clone/utilities/upload_dialog.dart';

import '../data/models/claim.dart';
import '../utilities/app_constants.dart';
import '../data/repositories/data_upload_repo.dart';

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
    String _fileName = "/${claim.claimNumber}_$_currentTime.aac";
    await _audioRecorder!.startRecorder(toFile: _saveDirectory.path + _fileName, codec: Codec.aacADTS);
  }

  Future<void> _stop(BuildContext context, double latitude, double longitude) async {
    if (!_isRecorderInitialized) return;
    String? _path = await _audioRecorder!.stopRecorder();
    File _audioFile = File(_path!);
    final DataUploadRepository _repository = DataUploadRepository();
    showProgressDialog(context);
    bool _result = await _repository.uploadData(
      claimNumber: claim.claimNumber,
      latitude: latitude,
      longitude: longitude,
      file: _audioFile,
    );
    Navigator.pop(context);
    if (_result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.fileUploaded),
          backgroundColor: Colors.green,
        ),
      );
      _audioFile.delete();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.fileUploadFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> toggleRecording(BuildContext context, double latitude, double longitude) async {
    if (_audioRecorder!.isStopped) {
      await _record();
    } else {
      await _stop(context, latitude, longitude);
    }
  }
}
