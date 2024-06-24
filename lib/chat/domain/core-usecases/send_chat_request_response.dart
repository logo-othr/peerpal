import 'package:peerpal/chat/domain/repositorys/chat_repository.dart';

class SendChatRequestResponse {
  final ChatRepository repository;

  SendChatRequestResponse(this.repository);

  Future<void> call(String chatPartnerId, String chatId, bool response) async {
    return await repository.sendChatRequestResponse(
        chatPartnerId, response, chatId);
  }
}
