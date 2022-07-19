import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/peerpal_user/domain/peerpal_user.dart';

class UserChat {
  UserChat({required this.chat, required this.user});

  final Chat chat;
  final PeerPALUser user;
}
