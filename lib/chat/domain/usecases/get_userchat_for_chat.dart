import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

class GetUserChatForChat {
  final ChatRepository chatRepository;
  final AppUserRepository appUserRepository;

  GetUserChatForChat(this.chatRepository, this.appUserRepository);

  Stream<List<UserChat>> call(
      Stream<List<Chat>> chatStream, bool filter) async* {
    // ToDo: Move filter in seperate usecase
    var appUserId = appUserRepository.currentUser.id;
    List<UserChat> userChats = <UserChat>[];
    await for (List<Chat> chatList in chatStream) {
      userChats.clear();
      for (Chat chat in chatList) {
        if(chat.chatRequestAccepted == true) {
          userChats = await addChats(chat, appUserId);
        } else if(chat.chatRequestAccepted == false &&
            chat.startedBy == appUserId) {
          userChats = await addChats(chat, appUserId);
        } else if(filter == false) {
          userChats = await addChats(chat, appUserId);
        }
        yield userChats;
      }
    }
  }

  Future<List<UserChat>> addChats(Chat chat, String appUserId) async {
    List<UserChat> userChats = <UserChat>[];
    List<String> userIds = chat.uids;
    userIds.remove(appUserId);
    PeerPALUser peerPALUser =
        await appUserRepository.getUserInformation(userIds.first);
    UserChat userChat = UserChat(chat: chat, user: peerPALUser);
    userChats.add(userChat);
    return userChats;
  }
}
