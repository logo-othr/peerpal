import 'package:peerpal/chat/domain/repositorys/chat_repository.dart';

class SendRequestResponse {
  final ChatRepository chatRepository;

  SendRequestResponse(this.chatRepository);

  Future<void> call(String currentUserId, String chatPartnerId, bool response,
      String chatId) async {
    return chatRepository.sendChatRequestResponse(
        chatPartnerId, response, chatId);
  }
}
