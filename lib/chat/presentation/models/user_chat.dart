import 'package:equatable/equatable.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

class UserChat implements Equatable{

  UserChat({required this.chat, required this.user});
  final Chat chat;
  final PeerPALUser user;

  @override
  // TODO: implement props
  List<Object?> get props => [chat, user];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();

}