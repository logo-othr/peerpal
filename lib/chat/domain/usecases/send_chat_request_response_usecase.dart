import 'package:peerpal/chat/domain/repository/chat_repository.dart';

class SendChatRequestResponseUseCase {
  final ChatRepository chatRepository;

  SendChatRequestResponseUseCase(this.chatRepository);

  Future<void> call(String currentUserId, String chatPartnerId, bool response,
      String chatId) async {
    return chatRepository.sendChatRequestResponse(
        chatPartnerId, response, chatId);
  }
}
