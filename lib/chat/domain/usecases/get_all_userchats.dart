import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';

class GetAllUserChats {
  final ChatRepository chatRepository;
  final AppUserRepository userRepository;
  final AuthenticationRepository authenticationRepository;

  GetAllUserChats(
      {required this.chatRepository,
      required this.userRepository,
      required this.authenticationRepository});

  Stream<List<UserChat>> call() {
    String currentUserId = authenticationRepository.currentUser.id;
    return chatRepository.getChats().asyncMap((chatList) async {
      List<UserChat> userChats = [];
      for (var chat in chatList) {
        final partnerId = chat.uids.firstWhere((id) => id != currentUserId);
        final user = await userRepository.getUser(partnerId);
        userChats.add(UserChat(chat: chat, user: user));
      }
      return userChats;
    });
  }
}
