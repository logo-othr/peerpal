import 'package:peerpal/chatv2/domain/models/chat.dart';
import 'package:peerpal/chatv2/domain/repositorys/chat_repository.dart';

class GetChats {
  final ChatRepository repository;

  GetChats(this.repository);

  Stream<List<Chat>> call(String userId) {
    return repository.chatsStream(userId);
  }
}
