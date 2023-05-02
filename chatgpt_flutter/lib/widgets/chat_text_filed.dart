import 'package:chatgpt_flutter/data/chat_message.dart';
import 'package:chatgpt_flutter/providers/messages_provider.dart';
import 'package:chatgpt_flutter/providers/recorder_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/role.dart';

class ChatTextField extends ConsumerWidget {
  ChatTextField({super.key});

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recorderState = ref.watch(recorderProvider.notifier);
    final isRecording = ref.watch(recordingProvider);
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 30,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            spreadRadius: 1,
            blurRadius: 20,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async{

                      if (recorderState.recorder.isRecording) {
                        await ref.read(recorderProvider.notifier).stop();
                      } else {
                        await ref.read(recorderProvider.notifier).start();
                      }

                      ref.read(recordingProvider.notifier)
                          .changeTheRecordingStatus();
                    },
                    child: Icon(
                      isRecording ? Icons.stop : Icons.mic,
                      color: isRecording ? Colors.red : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 10),
                  isRecording
                      ? StreamBuilder(
                          stream: ref
                              .read(recorderProvider.notifier)
                              .recorder
                              .onProgress,
                          builder: (context, snapshot) {
                            final duration = snapshot.hasData
                                ? snapshot.data!.duration
                                : Duration.zero;

                            // return Text('${duration.inSeconds} s');
                            return Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  enabled: false,
                                  border: InputBorder.none,
                                  hintText: '${duration.inSeconds} s',
                                ),
                              ),
                            );
                          },
                        )
                      : Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type a message',
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          isRecording
              ? Container()
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: const DecorationImage(
                      image: AssetImage('assets/gradient.png'),
                      fit: BoxFit.fitHeight,
                      alignment: Alignment.centerRight,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () async {
                        ref.watch(messagesProvider.notifier).addMessage(
                              ChatMessage(
                                text: _controller.text,
                                role: Role.user,
                                timestamp: DateTime.now(),
                              ),
                            );
                        _controller.clear();
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: const SizedBox(
                        width: 45,
                        height: 45,
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
