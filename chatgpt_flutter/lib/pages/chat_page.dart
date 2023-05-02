import 'package:chatgpt_flutter/widgets/chat_text_filed.dart';
import 'package:chatgpt_flutter/widgets/chat_messages_list_view.dart';
import 'package:flutter/material.dart';

import '../widgets/chat_header.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
