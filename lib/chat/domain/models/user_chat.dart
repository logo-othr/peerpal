import 'package:equatable/equatable.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

class UserChat extends Equatable {
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

  @override
  List<Object?> get props => [chat, user];
}
