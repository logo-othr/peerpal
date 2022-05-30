import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

class SendChatMessage {
  final ChatRepository chatRepository;

  SendChatMessage(this.chatRepository);

  Future<void> call(
   PeerPALUser chatPartner,
    String? chatId,
    String content,
    String type,
  ) async {
    return chatRepository.sendChatMessage(chatPartner, chatId, content, type);
  }
}