part of 'chat_list_cubit.dart';

enum ChatListStatus { initial, loading, success }

class ChatListState extends Equatable {
  const ChatListState({
    this.status = ChatListStatus.initial,
    this.chats = const [],
  });

  final ChatListStatus status;
  final List<UserChat> chats;

  ChatListState copyWith({
    ChatListStatus? status,
    List<UserChat>? chats,
  }) {
    return ChatListState(
        status: status ?? this.status, chats: chats ?? this.chats);
  }

  @override
  List<Object> get props => [status, chats];
}
