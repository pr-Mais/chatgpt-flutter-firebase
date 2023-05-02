import 'dart:io';

import 'package:chatgpt_flutter/data/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:developer' as devtools;

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addMessage(ChatMessage message) async {
    await _firestore.collection("messages").add(message.toJson());
  }

  Stream<List<QueryDocumentSnapshot<ChatMessage>>> streamMessages() {
    try {
      return _firestore
          .collection('messages')
          .withConverter(
        fromFirestore: (snapshot, _) =>
            ChatMessage.fromJson(snapshot.data()!),
        toFirestore: (message, _) => message.toJson(),
      )
          .snapshots()
          .map(
            (event) {
          final sorted = event.docs;
          sorted
              .sort((a, b) => b.data().timestamp.compareTo(a.data().timestamp));
          return sorted;
        },
      );
    } catch (e) {
      print(e);
      return Stream.error(e);
    }
  }

  Future<String> uploadTheVoiceToFirebaseStorage(File file) async {
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
}
