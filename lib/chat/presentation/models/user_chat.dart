import 'package:equatable/equatable.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

class UserChat implements Equatable {
  UserChat({required this.chat, required this.user});

  final Chat chat;
  final PeerPALUser user;

  @override
  List<Object?> get props => [chat, user];

  @override
  bool? get stringify => true;
}
