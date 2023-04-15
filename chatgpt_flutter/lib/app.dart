import 'package:flutter/material.dart';

import 'pages/chat_page.dart';

class ChatgptApp extends StatelessWidget {
  const ChatgptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatPage(),
    );
  }
}
