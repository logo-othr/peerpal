import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

class GetUserChatForChat {
  final ChatRepository chatRepository;
  final AppUserRepository appUserRepository;
  final AuthenticationRepository authenticationRepository;

  GetUserChatForChat(this.chatRepository, this.appUserRepository,
      this.authenticationRepository);

  Stream<List<UserChat>> call(
      Stream<List<Chat>> chatStream, bool filter) async* {
    // ToDo: Move filter in seperate usecase
    var appUserId = authenticationRepository.currentUser.id;
    List<UserChat> userChats = <UserChat>[];
    await for (List<Chat> chatList in chatStream) {
      userChats.clear();
      for (Chat chat in chatList) {
        if (chat.chatRequestAccepted == true) {
          UserChat userChat = await chatToUserChat(chat, appUserId);
          userChats.add(userChat);
        } else if (chat.chatRequestAccepted == false &&
            chat.startedBy == appUserId) {
          UserChat userChat = await chatToUserChat(chat, appUserId);
          userChats.add(userChat);
        } else if (filter == false) {
          UserChat userChat = await chatToUserChat(chat, appUserId);
          userChats.add(userChat);
        }
      }
      yield userChats;
    }
  }

  Future<UserChat> chatToUserChat(Chat chat, String appUserId) async {
    List<String> userIds = chat.uids;
    userIds.remove(appUserId);
    PeerPALUser peerPALUser =
        await appUserRepository.getUserInformation(userIds.first);

    /*bool redDot = false;
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String? timestamp =
    prefs.getString("${chat.chatId}-last-message-clicked-timestamp");
    int lastMessageClickedTimestamp = int.parse(timestamp ?? "0");
    int lastMessageTimestamp = int.parse(chat.lastMessage?.timestamp ?? "0");
    if (lastMessageClickedTimestamp < lastMessageTimestamp) redDot = true;
    logger.i("Chat with user ${peerPALUser.name} has a red dot: ${redDot}");*/

    UserChat userChat = UserChat(chat: chat, user: peerPALUser);
    return userChat;
  }
}