import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/chat_message.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  get messagesConverter => _firestore.collection('messages').withConverter(
        fromFirestore: (snapshot, _) => ChatMessage.fromJson(snapshot.data()!),
        toFirestore: (message, _) => message.toJson(),
      );

  Future<void> addMessage(ChatMessage message) async {
    await messagesConverter.add(message);
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
}
