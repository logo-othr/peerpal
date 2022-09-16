import 'package:peerpal/chat/domain/message_type.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/peerpal_user/domain/peerpal_user.dart';

abstract class ChatRepository {
  Stream<List<Chat>> getChatListForUserId(String currentUserId);

  Stream<List<ChatMessage>> getChatMessagesForChat(String chatId);

  Future<void> sendChatMessage(PeerPALUser userInformation, String? chatId,
      String payload, MessageType type);

  Stream<int> messageCountForChat(String chatId);

  Future<void> sendChatRequestResponse(String currentUserId, String chatPartnerId, bool response, String chatId);
}
