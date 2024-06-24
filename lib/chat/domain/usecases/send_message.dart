import 'package:peerpal/chat/domain/enums/message_type.dart';
import 'package:peerpal/chat/domain/repositorys/chat_repository.dart';

class SendMessage {
  final ChatRepository chatRepository;

  SendMessage(this.chatRepository);

  Future<void> call(
    String senderId,
    String? chatId,
    String payload,
    MessageType type,
  ) async {
    return chatRepository.sendMessage(senderId, chatId, payload, type);
  }
}
