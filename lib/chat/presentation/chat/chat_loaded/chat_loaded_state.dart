part of 'chat_loaded_cubit.dart';

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