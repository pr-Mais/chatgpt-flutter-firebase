import 'package:chatgpt_flutter/firebase_options.dart';
import 'package:chatgpt_flutter/pages/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> _initializeFirebase({bool withEmulator = true}) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (withEmulator) {
    FirebaseFunctions.instance.useFunctionsEmulator('127.0.0.1', 5001);
    FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8080);
    FirebaseStorage.instance.useStorageEmulator('127.0.0.1', 4501);
  } else {
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeFirebase(withEmulator: false);
  runApp(const ProviderScope(child: ChatGPTApp()));
}

class ChatGPTApp extends StatelessWidget {
  const ChatGPTApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatGPT App',
      home: ChatPage(),
    );
  }
}
