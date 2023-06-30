import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';

class ChatToUserChatUseCase {
  final ChatRepository chatRepository;
  final AppUserRepository appUserRepository;
  final AuthenticationRepository authenticationRepository;

  ChatToUserChatUseCase(this.chatRepository, this.appUserRepository,
      this.authenticationRepository);

  Stream<List<UserChat>> call(
      Stream<List<Chat>> chatStream, bool filter) async* {
    var appUserId = authenticationRepository.currentUser.id;
    await for (List<Chat> chatList in chatStream) {
      List<UserChat> userChats = <UserChat>[];
      for (Chat chat in chatList) {
        if (shouldAddChat(chat, appUserId, filter)) {
          UserChat userChat = await convertChatToUserChat(chat, appUserId);
          userChats.add(userChat);
        }
      }
      yield userChats;
    }
  }

  bool shouldAddChat(Chat chat, String appUserId, bool filter) {
    return (chat.chatRequestAccepted == true) ||
        (chat.chatRequestAccepted == false && chat.startedBy == appUserId) ||
        (!filter);
  }

  Future<UserChat> convertChatToUserChat(Chat chat, String appUserId) async {
    var userIds = List<String>.from(chat.uids);
    userIds.remove(appUserId);
    var peerUser = await appUserRepository.getUser(userIds.first);
    return UserChat(chat: chat, user: peerUser);
  }
}
