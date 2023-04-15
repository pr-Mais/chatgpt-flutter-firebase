import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/chat_message.dart';
import '../services/database_service.dart';

final dbServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

final messagesStreamProvider =
    StreamProvider<List<QueryDocumentSnapshot<ChatMessage>>>((ref) {
  return ref.watch(dbServiceProvider).streamMessages();
});

final messagesProvider =
    NotifierProvider<MessagesProvider, List<ChatMessage>>(() {
  return MessagesProvider();
});

class MessagesProvider extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() {
    final messages = ref.watch(messagesStreamProvider).mapOrNull(
              data: (data) => data.value,
            ) ??
        [];

    return messages.map((e) => e.data()).toList();
  }

  void addMessage(ChatMessage message) async {
    state = [...state, message]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    await ref.read(dbServiceProvider).addMessage(message);
  }
}
