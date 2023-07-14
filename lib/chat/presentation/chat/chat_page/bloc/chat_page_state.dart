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

class ChatLoadingState extends ChatPageState {
  final PeerPALUser chatPartner;

  ChatLoadingState({required this.chatPartner});

  @override
  List<Object?> get props => [chatPartner];
}

class ChatLoadedState extends ChatPageState {
  final PeerPALUser chatPartner; // ToDo: Remove chatPartner?
  final Stream<List<ChatMessage>> messages;
  final String userId;
  final UserChat userChat;
  final PeerPALUser appUser;

  @override
  List<Object?> get props => [chatPartner, messages, userId, userChat, appUser];

  ChatLoadedState(
      {required this.chatPartner,
      required this.messages,
      required this.userId,
      required this.userChat,
      required this.appUser});
}

class WaitingForChatState extends ChatPageState {
  final PeerPALUser chatPartner;
  final PeerPALUser appUser;

  @override
  List<Object?> get props => [chatPartner, appUser];

  WaitingForChatState({required this.chatPartner, required this.appUser});
}


class ChatPageError extends ChatPageState {
  final String message;

  @override
  List<Object?> get props => [message];

  ChatPageError({required this.message});
}
