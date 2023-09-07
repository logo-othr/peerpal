import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

class UserChat {
  UserChat({required this.chat, required this.user});

  final Chat chat;
  final PeerPALUser user;

  UserChat copyWith({
    Chat? chat,
    PeerPALUser? user,
  }) {
    return UserChat(
      chat: chat ?? this.chat,
      user: user ?? this.user,
    );
  }
}
