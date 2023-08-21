import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'package:location/location.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/models/withdrawal.dart';
import '../../data/models/document.dart';
import '../../utilities/document_utilities.dart';
import '../../utilities/show_snackbars.dart';
import '../../widgets/buttons.dart';

class AudioRecordArguments {
  final Withdrawal claim;
  final LocationData locationData;

  const AudioRecordArguments(this.claim, this.locationData);
}

class AudioRecordPage extends StatefulWidget {
  final AudioRecordArguments arguments;
  const AudioRecordPage({Key? key, required this.arguments}) : super(key: key);

  @override
  State<AudioRecordPage> createState() => _AudioRecordPageState();
}

class _AudioRecordPageState extends State<AudioRecordPage> {
  bool _isRecording = false;
  final FlutterSoundRecord _audioRecorder = FlutterSoundRecord();
  Duration _duration = const Duration();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _isRecording = false;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => _addTime());
  }

  void _stopTimer() {
    _timer!.cancel();
  }

  void _resetTimer() {
    setState(() {
      _duration = const Duration();
    });
  }

  void _addTime() {
    const int _addSeconds = 1;
    setState(() {
      final seconds = _duration.inSeconds + _addSeconds;
      _duration = Duration(seconds: seconds);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(
          onPressed: () {
            if (_isRecording) {
              showInfoSnackBar(
                context,
                "Recording is in progress. Stop recording to go back.",
                color: Colors.orange,
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text("Record audio"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30.h),
              Text(
                "Claim number",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.arguments.claim.claimId,
                  maxLines: 2,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 50.h),
                child: AudioTimer(duration: _duration),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30.h),
                child: _recorderButton(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _recorderButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        if (!_isRecording) {
          log("Starting record");
          try {
            int currentTime = DateTime.now().microsecondsSinceEpoch;
            Directory? directory = await getExternalStorageDirectory();
            Directory? saveDirectory = await Directory(directory!.path + "/Audio").create();
            String fileName = saveDirectory.path + "/${widget.arguments.claim.claimId}_$currentTime.aac";
            await File(fileName).create(recursive: true);
            await _audioRecorder.start(path: fileName);
            bool isRecording = await _audioRecorder.isRecording();
            setState(() {
              _isRecording = isRecording;
            });
            _startTimer();
          } on Exception catch (e) {
            log(e.toString());
            return;
          }
        } else {
          final String? path = await _audioRecorder.stop();
          _stopTimer();
          _resetTimer();
          setState(() => _isRecording = false);
          if (path != null) {
            await DocumentUtilities.documentUploadDialog(
              context,
              widget.arguments.claim.claimId,
              DocumentType.audio,
              file: File(path),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _isRecording ? Colors.red : Colors.green,
        foregroundColor: Colors.white,
      ),
      icon: Icon(_isRecording ? Icons.stop : Icons.mic),
      label: Text(_isRecording ? 'Stop recording' : 'Start recording'),
    );
  }
}

class AudioTimer extends StatefulWidget {
  final Duration duration;

  const AudioTimer({Key? key, required this.duration}) : super(key: key);

  @override
  State<AudioTimer> createState() => _AudioTimerState();
}

class _AudioTimerState extends State<AudioTimer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        height: 300.h,
        width: 300.h,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Theme.of(context).primaryColor),
        child: Center(
          child: _buildTime(),
        ),
      ),
    );
  }

  Widget _buildTime() {
    final String minutes = _twoDigits(widget.duration.inMinutes.remainder(60));
    final String seconds = _twoDigits(widget.duration.inSeconds.remainder(60));
    return FittedBox(
      child: Text(
        "$minutes:$seconds",
        style: TextStyle(color: Colors.white, fontSize: 80.sp),
      ),
    );
  }

  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }
}
