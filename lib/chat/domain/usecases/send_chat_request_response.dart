import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

class SendChatRequestResponse {
  final ChatRepository chatRepository;

  SendChatRequestResponse(this.chatRepository);

  Future<void> call(
      String currentUserId, String chatPartnerId, bool response, String chatId
      ) async {
    return chatRepository.sendChatRequestResponse(currentUserId, chatPartnerId, response, chatId);
  }
}
