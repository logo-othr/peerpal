import 'dart:async';

import 'package:peerpal/chat/domain/message_type.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

abstract class ChatRepository {
  Stream<List<Chat>> getChats();

  Future<void> sendChatMessage(PeerPALUser userInformation, String? chatId,
      String message, MessageType type);

  Future<void> sendChatRequestResponse(
      String chatPartnerId, bool response, String chatId);

  Stream<int> messageCountForChat(String chatId);

  Stream<List<ChatMessage>> getChatMessagesForChat(String chatId);
}
