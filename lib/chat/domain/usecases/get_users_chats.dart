import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';

class GetUsersChats {
  final ChatRepository chatRepository;
  final AppUserRepository appUserRepository;
  final AuthenticationRepository authenticationRepository;

  GetUsersChats(this.chatRepository, this.authenticationRepository,
      this.appUserRepository);

  Stream<List<UserChat>> call(bool filter) async* {
    Stream<List<Chat>> chatStream = chatRepository.getChats();

    var appUserId = authenticationRepository.currentUser.id;

    await for (List<Chat> chatList in chatStream) {
      List<UserChat> userChats = <UserChat>[];
      for (Chat chat in chatList) {
        if (chat.chatRequestAccepted == true) {
          UserChat userChat = await convertChatToUserChat(chat, appUserId);
          userChats.add(userChat);
        } else if (chat.chatRequestAccepted == false &&
            chat.startedBy == appUserId) {
          UserChat userChat = await convertChatToUserChat(chat, appUserId);
          userChats.add(userChat);
        } else if (filter == false) {
          UserChat userChat = await convertChatToUserChat(chat, appUserId);
          userChats.add(userChat);
        }
      }
      yield userChats;
    }
  }



  Future<UserChat> convertChatToUserChat(Chat chat, String appUserId) async {
    var userIds = List<String>.from(chat.uids);
    userIds.remove(appUserId);
    var peerUser = await appUserRepository.getUser(userIds.first);
    return UserChat(chat: chat, user: peerUser);
  }
}