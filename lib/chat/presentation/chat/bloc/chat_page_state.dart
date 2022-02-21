part of 'chat_page_bloc.dart';

enum ChatPageStatus { initial, success, error }

abstract class ChatPageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatPageInitial extends ChatPageState {
  @override
  List<Object?> get props => [];
}

class ChatPageLoading extends ChatPageState {
  final PeerPALUser chatPartner;

  ChatPageLoading({required this.chatPartner});

  @override
  List<Object?> get props => [chatPartner];
}

class ChatPageChatExists extends ChatPageState {
  final PeerPALUser chatPartner; // ToDo: Remove chatPartner?
  final Stream<List<ChatMessage>> messages;
  final String userId;
  final UserChat userChat;
  final PeerPALUser appUser;

  @override
  List<Object?> get props => [chatPartner, messages, userId, userChat, appUser];

  ChatPageChatExists(
      {required this.chatPartner,
      required this.messages,
      required this.userId,
      required this.userChat,
      required this.appUser});
}

class ChatPageChatNotExists extends ChatPageState {
  final PeerPALUser chatPartner;

  @override
  List<Object?> get props => [chatPartner];

  ChatPageChatNotExists({required this.chatPartner});
}


class ChatPageError extends ChatPageState {
  final String message;

  @override
  List<Object?> get props => [message];

  ChatPageError({required this.message});
}
