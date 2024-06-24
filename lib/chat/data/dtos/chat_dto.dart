import 'package:json_annotation/json_annotation.dart';
import 'package:peerpal/chat/data/dtos/chat_message_dto.dart';
import 'package:peerpal/chat/domain/models/chat.dart';

part 'chat_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ChatDTO extends Chat {
  ChatMessageDTO? lastMessage;

  ChatDTO(List<String> uids, String chatId, this.lastMessage,
      String lastUpdated, bool chatRequestAccepted, String startedBy)
      : super(
            uids: uids,
            chatId: chatId,
            lastMessage: lastMessage,
            lastUpdated: lastUpdated,
            chatRequestAccepted: chatRequestAccepted,
            startedBy: startedBy);

  factory ChatDTO.fromJson(Map<String, dynamic> json) =>
      _$ChatDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ChatDTOToJson(this);
}
