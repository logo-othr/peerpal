// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatDTO _$ChatDTOFromJson(Map<String, dynamic> json) => ChatDTO(
      (json['uids'] as List<dynamic>).map((e) => e as String).toList(),
      json['chatId'] as String,
      json['lastMessage'] == null
          ? null
          : ChatMessageDTO.fromJson(
              json['lastMessage'] as Map<String, dynamic>),
      json['lastUpdated'] as String,
      json['chatRequestAccepted'] as bool,
      json['startedBy'] as String,
    );

Map<String, dynamic> _$ChatDTOToJson(ChatDTO instance) => <String, dynamic>{
      'uids': instance.uids,
      'chatId': instance.chatId,
      'lastUpdated': instance.lastUpdated,
      'chatRequestAccepted': instance.chatRequestAccepted,
      'startedBy': instance.startedBy,
      'lastMessage': instance.lastMessage?.toJson(),
    };
