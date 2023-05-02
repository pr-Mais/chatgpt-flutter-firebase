import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as devtools;

Future<String> uploadFile(File file) async {
  try {
    Reference ref = FirebaseStorage.instance.ref("voices").child("voice.wav");

    await ref.putFile(file);

    String downloadURL = await ref.getDownloadURL();

    return downloadURL;
  } catch (e) {
    devtools.log(e.toString());
    return '';
  }
}

class RecorderState extends StateNotifier<bool> {
  RecorderState() : super(false);

  final recorder = FlutterSoundRecorder();

  Future<void> start() async {
    await initRecorder();
    if (state) return;
    await recorder.startRecorder(toFile: 'audio.wav');
    state = true;
  }

  Future<void> initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw "Mic Permission Not Granted";
    }

    await recorder.openRecorder();

    recorder.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
  }

  Future<String> stop() async {
    if (!state) return '';

    final path = await recorder.stopRecorder();
    final audioFile = File(path!);

    //TODO i this way is bad causes of we are not using any provider to contact with the db
    //TODO rather than that we already have a method called "uploadTheVoiceToFirebaseStorage" in the DatabaseServices class

    String downloadURL = await uploadFile(audioFile);
    if (downloadURL.isNotEmpty) {
      devtools.log('Recorded Audio Uploaded: $audioFile');
    } else {
      devtools.log('ERROR DURING THE UPLOADING: $audioFile');
    }

    state = false;
    devtools.log('Recorded Audio: $audioFile');
    return path;
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }
}

/////////////////////////////////////////////////////

class RecordingNotifier extends StateNotifier<bool> {
  RecordingNotifier() : super(false);

  void changeTheRecordingStatus() {
    state = !state;
  }

  bool get stateOfRecording => state;
}
