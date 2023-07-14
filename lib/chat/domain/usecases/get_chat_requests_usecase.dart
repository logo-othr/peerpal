import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';

class GetChatRequestsUseCase {
  final ChatRepository chatRepository;
  final AppUserRepository appUserRepository;
  final AuthenticationRepository authenticationRepository;

  GetChatRequestsUseCase(this.chatRepository, this.appUserRepository,
      this.authenticationRepository);

  Stream<List<UserChat>> call(Stream<List<UserChat>> chatStream) async* {
    final appUserId = authenticationRepository.currentUser.id;

    await for (List<UserChat> chatList in chatStream) {
      final userChats = await Future.wait(chatList.map((chat) async {
        if (chat.chat.chatRequestAccepted == false &&
            chat.chat.startedBy != appUserId) {
          return chat;
        }
      }));

      yield userChats.whereType<UserChat>().toList();
    }
  }
}
