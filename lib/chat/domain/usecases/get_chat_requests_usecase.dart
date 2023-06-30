import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

class GetChatRequestsUseCase {
  final ChatRepository chatRepository;
  final AppUserRepository appUserRepository;
  final AuthenticationRepository authenticationRepository;

  GetChatRequestsUseCase(this.chatRepository, this.appUserRepository,
      this.authenticationRepository);

  Stream<List<UserChat>> call(Stream<List<Chat>> chatStream) async* {
    final appUserId = authenticationRepository.currentUser.id;

    await for (List<Chat> chatList in chatStream) {
      final userChats = await Future.wait(chatList.map((chat) async {
        if (chat.chatRequestAccepted == false && chat.startedBy != appUserId) {
          final String? peerUserId = chat.uids
              .firstWhere((userId) => userId != appUserId, orElse: null);
          if (peerUserId == null) {
            print('No  user ID found in chat');
          } else {
            try {
              final peerPALUser = await appUserRepository.getUser(peerUserId);
              return _createUserChat(chat, peerPALUser);
            } catch (e) {
              print('Failed to fetch user information for $peerUserId: $e');
            }
          }
        }
      }));

      yield userChats.whereType<UserChat>().toList();
    }
  }

  UserChat _createUserChat(Chat chat, PeerPALUser peerPALUser) {
    return UserChat(chat: chat, user: peerPALUser);
  }
}
