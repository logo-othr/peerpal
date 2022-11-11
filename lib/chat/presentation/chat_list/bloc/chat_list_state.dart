part of 'chat_list_bloc.dart';

enum ChatListStatus { initial, success, error, chatClicked, streamUpdated }

class ChatListState extends Equatable {
  const ChatListState(
      {this.status = ChatListStatus.initial,
      this.chats = const Stream.empty(),
      this.chatRequests = const Stream.empty(),
      this.redDot = const {},
      this.lastClicked = const {}});

  final ChatListStatus status;
  final Stream<List<UserChat>> chats;
  final Stream<List<UserChat>> chatRequests;
  final Map<String, String> redDot;
  final Map<String, String> lastClicked;

  ChatListState copyWith({
    ChatListStatus? status,
    Stream<List<UserChat>>? chats,
    Stream<List<UserChat>>? chatRequests,
    Map<String, String>? redDot,
    Map<String, String>? lastClicked,
  }) {
    return ChatListState(
        status: status ?? this.status,
        chats: chats ?? this.chats,
        chatRequests: chatRequests ?? this.chatRequests,
        redDot: redDot ?? this.redDot,
        lastClicked: lastClicked ?? this.lastClicked);
  }

  @override
  List<Object> get props => [status, chats, chatRequests, redDot, lastClicked];
}
