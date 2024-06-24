// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageDTO _$ChatMessageDTOFromJson(Map<String, dynamic> json) =>
    ChatMessageDTO(
      json['message'] as String,
      json['timestamp'] as String,
      json['type'] as String,
      json['userId'] as String,
    );

Map<String, dynamic> _$ChatMessageDTOToJson(ChatMessageDTO instance) =>
    <String, dynamic>{
      'message': instance.message,
      'timestamp': instance.timestamp,
      'type': instance.type,
      'userId': instance.userId,
    };
