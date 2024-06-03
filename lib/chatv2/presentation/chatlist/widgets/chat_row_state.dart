part of 'chat_row_cubit.dart';

enum ChatRowStatus { initial, loading, success }

class ChatRowState extends Equatable {
  const ChatRowState({
    this.chat = null,
    this.status = ChatRowStatus.initial,
    this.user = PeerPALUser.empty,
  });

  final ChatRowStatus status;
  final PeerPALUser user;
  final Chat? chat;

  ChatRowState copyWith({
    ChatRowStatus? status,
    PeerPALUser? user,
    Chat? chat,
  }) {
    return ChatRowState(
        status: status ?? this.status,
        user: user ?? this.user,
        chat: chat ?? this.chat);
  }

  @override
  List<Object> get props => [status, user];
}
