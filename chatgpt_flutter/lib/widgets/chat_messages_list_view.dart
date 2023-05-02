import 'package:chatgpt_flutter/providers/messages_provider.dart';
import 'package:chatgpt_flutter/widgets/chat_empty.dart';
import 'package:chatgpt_flutter/widgets/chat_message_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/chat_header.dart';

class ChatMessagesListView extends ConsumerWidget {
  const ChatMessagesListView({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
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