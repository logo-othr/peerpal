import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/chat/domain/repositorys/chat_repository.dart';

class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  Stream<List<ChatMessage>> call(String chatId) {
    return repository.messageStream(chatId);
  }
}
