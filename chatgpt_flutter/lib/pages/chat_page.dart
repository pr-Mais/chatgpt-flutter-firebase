import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/messages_provider.dart';
import '../widgets/chat_empty.dart';
import '../widgets/chat_header.dart';
import '../widgets/chat_message_item.dart';
import '../widgets/chat_text_field.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ChatHeader(),
          const Expanded(
            child: ChatMessagesListView(),
          ),
          ChatTextField(),
        ],
      ),
    );
  }
}

class ChatMessagesListView extends ConsumerStatefulWidget {
  const ChatMessagesListView({super.key});

  @override
  ConsumerState<ChatMessagesListView> createState() =>
      _ChatMessagesListViewState();
}

class _ChatMessagesListViewState extends ConsumerState<ChatMessagesListView> {
  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messagesProvider);

    if (messages.isEmpty) {
      return const ChatEmpty();
    }

    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      shrinkWrap: true,
      itemBuilder: (context, index) => ChatMessageItem(
        message: messages[index],
      ),
    );
  }
}
