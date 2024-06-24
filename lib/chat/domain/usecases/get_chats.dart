import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/repositorys/chat_repository.dart';

class GetChats {
  final ChatRepository repository;

  GetChats(this.repository);

  Stream<List<Chat>> call(String userId) {
    return repository.chatsStream(userId);
  }
}
