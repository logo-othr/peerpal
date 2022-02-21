part of 'chat_list_bloc.dart';


enum ChatListStatus { initial, success, error }

class ChatListState extends Equatable {
  const ChatListState({
    this.status = ChatListStatus.initial,
    this.chats =  const Stream.empty(),
    this.chatRequests = const Stream.empty()
  });

  final ChatListStatus status;
  final Stream<List<UserChat>> chats;
  final Stream<List<UserChat>> chatRequests;

  ChatListState copyWith({
    ChatListStatus? status,
    Stream<List<UserChat>>? chats,
    Stream<List<UserChat>>? chatRequests,


  }) {
    return ChatListState(
      status: status ?? this.status,
      chats: chats ?? this.chats,
      chatRequests: chatRequests ?? this.chatRequests
    );
  }

  @override
  List<Object> get props => [status, chats, chatRequests];
}
