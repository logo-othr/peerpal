part of 'chat_requests_cubit.dart';

enum ChatRequestsStatus { initial, loading, success }

class ChatRequestsState extends Equatable {
  final ChatRequestsStatus status;
  final List<Chat> requests;

  const ChatRequestsState({
    this.status = ChatRequestsStatus.initial,
    this.requests = const [],
  });

  ChatRequestsState copyWith({
    ChatRequestsStatus? status,
    List<Chat>? requests,
  }) {
    return ChatRequestsState(
        status: status ?? this.status, requests: requests ?? this.requests);
  }

  @override
  List<Object> get props => [status, requests];
}
