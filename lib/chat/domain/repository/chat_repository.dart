import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

abstract class ChatRepository {
  Stream<List<Chat>> getChatListForUserId(String currentUserId);

  Stream<List<ChatMessage>> getChatMessagesForChat(String chatId);

  Future<void> sendChatMessage(PeerPALUser userInformation, String? chatId, String message,
      String type);

  Future<void> sendChatRequestResponse(String currentUserId, String chatPartnerId, bool response);


}