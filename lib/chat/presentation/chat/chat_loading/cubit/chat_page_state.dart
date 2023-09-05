part of 'chat_page_cubit.dart';

abstract class ChatPageState extends Equatable {
  final String chatPartnerId;

  ChatPageState(this.chatPartnerId);

  @override
  List<Object?> get props => [];
}

class ChatPageInitial extends ChatPageState {
  final UserChat? currentChat;

  ChatPageInitial({this.currentChat, required chatPartnerId})
      : super(chatPartnerId);

  @override
  List<Object?> get props => [currentChat];
}

class ChatLoadingState extends ChatPageState {
  final UserChat? currentChat;

  ChatLoadingState({this.currentChat, required chatPartnerId})
      : super(chatPartnerId);

  @override
  List<Object?> get props => [currentChat];
}

class ChatLoadedState extends ChatPageState {
  final UserChat currentChat;
  final PeerPALUser currentUser;
  final PeerPALUser chatPartner;

  final List<ChatMessage> messages;

  ChatLoadedState(
      {required this.currentChat,
      required this.chatPartner,
      required this.currentUser,
      required chatPartnerId,
      required this.messages})
      : super(chatPartnerId);

  @override
  List<Object?> get props => [currentChat];
}

class NewChatState extends ChatPageState {
  final PeerPALUser chatPartner;
  final PeerPALUser currentUser;

  NewChatState(
      {required chatPartnerId,
      required this.chatPartner,
      required this.currentUser})
      : super(chatPartnerId);

  @override
  List<Object?> get props => [];
}
