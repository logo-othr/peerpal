import 'package:peerpal/chat/domain/message_type.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

class SendChatMessageUseCase {
  final ChatRepository chatRepository;

  SendChatMessageUseCase(this.chatRepository);

  Future<void> call(
    PeerPALUser chatPartner,
    String? chatId,
    String content,
    MessageType type,
  ) async {
    return chatRepository.sendChatMessage(chatPartner, chatId, content, type);
  }
}
