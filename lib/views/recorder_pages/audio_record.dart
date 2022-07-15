import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/claim.dart';
import '../../utilities/show_snackbars.dart';
import '../../utilities/sound_recorder.dart';
import '../../widgets/buttons.dart';

class AudioRecordArguments {
  final Claim claim;
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
  SoundRecorder? _recorder;
  Duration _duration = const Duration();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _recorder = SoundRecorder(widget.arguments.claim);
    _recorder!.init();
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
    _recorder!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(
          onPressed: () {
            if (_recorder!.isRecording) {
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
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                widget.arguments.claim.claimNumber,
                style: TextStyle(
                  fontSize: 28.sp,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
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
    final bool _isRecording = _recorder!.isRecording;
    final IconData _icon = _isRecording ? Icons.stop : Icons.mic;
    final String _text = _isRecording ? 'Stop recording' : 'Start recording';
    final Color _primary = _isRecording ? Colors.red : Colors.green;

    return ElevatedButton.icon(
      onPressed: () async {
        LocationData _locationData = widget.arguments.locationData;
        await _recorder!.toggleRecording(
          context,
          _locationData.latitude ?? 0,
          _locationData.longitude ?? 0,
        );
        if (!_isRecording) {
          _resetTimer();
          _startTimer();
        } else {
          _stopTimer();
        }
        setState(() {});
        log("Recorder state changed");
      },
      style: ElevatedButton.styleFrom(
        primary: _primary,
        onPrimary: Colors.white,
      ),
      icon: Icon(_icon),
      label: Text(_text),
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
