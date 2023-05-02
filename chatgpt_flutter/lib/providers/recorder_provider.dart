import 'package:chatgpt_flutter/notifiers/recorder_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recorderProvider = StateNotifierProvider((ref) => RecorderState());

final recordingProvider = StateNotifierProvider<RecordingNotifier, bool>((ref) => RecordingNotifier());
