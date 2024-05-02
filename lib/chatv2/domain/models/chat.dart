import 'package:equatable/equatable.dart';
import 'package:peerpal/chatv2/domain/models/chat_message.dart';

class Chat extends Equatable {
  final List<String> uids;
  final String chatId;
  final ChatMessage? lastMessage;
  final String lastUpdated;
  final bool chatRequestAccepted;
  final String startedBy;

  Chat(
      {required this.uids,
      required this.lastMessage,
      required this.chatId,
      required this.lastUpdated,
      required this.chatRequestAccepted,
      required this.startedBy});

  @override
  List<Object?> get props =>
      [uids, lastMessage, chatId, lastUpdated, chatRequestAccepted, startedBy];
}
