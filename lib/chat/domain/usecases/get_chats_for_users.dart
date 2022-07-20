import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';

class GetChatsForUser {
  final ChatRepository chatRepository;
  final AuthenticationRepository authenticationRepository;

  GetChatsForUser(this.chatRepository, this.authenticationRepository);

  Stream<List<Chat>> call() {
    String appUserId = authenticationRepository.currentUser.id;
    return chatRepository.getChatListForUserId(appUserId);
  }
}
