import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

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
      for (Chat chat in chatList) {
        final String partnerId =
            chat.uids.firstWhere((id) => id != currentUserId);
        final PeerPALUser user = await userRepository.getUser(partnerId);
        userChats.add(UserChat(chat: chat, user: user));
      }
      return userChats;
    });
  }
}
