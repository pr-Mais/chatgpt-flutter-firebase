import 'package:flutter/material.dart';

class ChatEmpty extends StatelessWidget {
  const ChatEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.18),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/avatar.png',
              width: 80,
              opacity: const AlwaysStoppedAnimation(0.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'No messages yet, send a message to start chatting',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}