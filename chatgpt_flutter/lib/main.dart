import 'package:chatgpt_flutter/app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase(withEmulator: true);

  runApp(
    const ProviderScope(child: ChatgptApp()),
  );
}

Future<void> _initializeFirebase({bool withEmulator = true}) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (withEmulator) {
    FirebaseFunctions.instance.useFunctionsEmulator('127.0.0.1', 5001);
    FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8080);
  }
}
