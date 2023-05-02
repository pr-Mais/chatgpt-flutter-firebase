import 'package:freezed_annotation/freezed_annotation.dart';
import 'role.dart';

import 'package:flutter/foundation.dart';
part 'chat_message.freezed.dart';
part 'chat_message.g.dart';


@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String text,
    required Role role,
    required DateTime timestamp,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, Object?> json) =>
      _$ChatMessageFromJson(json);
}
