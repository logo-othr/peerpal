part of 'chat_request_list_bloc.dart';

enum ChatRequestListStatus { initial, success, error }

class ChatRequestListState extends Equatable {
  const ChatRequestListState(
      {this.status = ChatRequestListStatus.initial,
      this.chatRequests = const Stream.empty()});

  final ChatRequestListStatus status;
  final Stream<List<UserChat>> chatRequests;

  ChatRequestListState copyWith({
    ChatRequestListStatus? status,
    Stream<List<UserChat>>? chatRequests,
  }) {
    return ChatRequestListState(
        status: status ?? this.status,
        chatRequests: chatRequests ?? this.chatRequests);
  }

  @override
  List<Object> get props => [status, chatRequests];
}
