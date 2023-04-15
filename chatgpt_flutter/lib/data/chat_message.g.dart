// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChatMessage _$$_ChatMessageFromJson(Map<String, dynamic> json) =>
    _$_ChatMessage(
      text: json['text'] as String,
      role: $enumDecode(_$RoleEnumMap, json['role']),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$_ChatMessageToJson(_$_ChatMessage instance) =>
    <String, dynamic>{
      'text': instance.text,
      'role': _$RoleEnumMap[instance.role]!,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$RoleEnumMap = {
  Role.user: 'user',
  Role.assistant: 'assistant',
};
