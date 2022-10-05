import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/discover/data/repository/app_user_repository.dart';
import 'package:peerpal/discover/domain/peerpal_user.dart';

class GetChatRequestForUser {
  final ChatRepository chatRepository;
  final AppUserRepository appUserRepository;
  final AuthenticationRepository authenticationRepository;

  GetChatRequestForUser(this.chatRepository, this.appUserRepository,
      this.authenticationRepository);

  Stream<List<UserChat>> call(Stream<List<Chat>> chatStream) async* {
    var appUserId = authenticationRepository.currentUser.id;
    List<UserChat> userChats = <UserChat>[];
    await for (List<Chat> chatList in chatStream) {
      userChats.clear();
      for (Chat chat in chatList) {
        if (chat.chatRequestAccepted == false && chat.startedBy != appUserId) {
          List<String> userIds = chat.uids;
          userIds.remove(appUserId);
          PeerPALUser peerPALUser =
          await appUserRepository.getUserInformation(userIds.first);
          UserChat userChat = UserChat(chat: chat, user: peerPALUser);
          userChats.add(userChat);
        }
      }
      yield userChats;
    }
  }
}
