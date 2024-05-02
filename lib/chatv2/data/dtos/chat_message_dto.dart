import 'package:json_annotation/json_annotation.dart';
import 'package:peerpal/chatv2/domain/models/chat_message.dart';

part 'chat_message_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ChatMessageDTO extends ChatMessage {
  ChatMessageDTO(String message, String timestamp, String type, String userId)
      : super(
          message: message,
          timestamp: timestamp,
          type: type,
          userId: userId,
        );

  factory ChatMessageDTO.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageDTOToJson(this);
}
