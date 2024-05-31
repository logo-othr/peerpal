import 'package:peerpal/chatv2/domain/enums/message_type.dart';
import 'package:peerpal/chatv2/domain/models/chat.dart';
import 'package:peerpal/chatv2/domain/models/chat_message.dart';

abstract class ChatRepository {
  // ToDo: Remove, old relict from chatv1

  Stream<List<Chat>> getChats();

  Stream<List<Chat>> chatsStream(String userId);

  Stream<List<ChatMessage>> messageStream(String chatId);

  Stream<int> messageCountStream(String chatId);

  Future<void> sendMessage(
      String senderId, String? chatId, String payload, MessageType messageType);

  Future<void> sendChatRequestResponse(
      String partnerId, bool response, String chatId);
}
