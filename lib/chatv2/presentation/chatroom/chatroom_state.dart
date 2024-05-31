part of 'chatroom_cubit.dart';

abstract class ChatroomState extends Equatable {
  final PeerPALUser chatPartner;
  final PeerPALUser appUser;

  const ChatroomState({required this.chatPartner, required this.appUser});

  List<Object> get props => [chatPartner, appUser];
}

class ChatroomInitial extends ChatroomState {
  ChatroomInitial({required chatPartner, required appUser})
      : super(chatPartner: chatPartner, appUser: appUser);

  @override
  List<Object> get props => [chatPartner, appUser];
}

class ChatroomLoading extends ChatroomState {
  ChatroomLoading({required chatPartner, required appUser})
      : super(chatPartner: chatPartner, appUser: appUser);

  @override
  List<Object> get props => [chatPartner, appUser];
}

class ChatroomUninitialized extends ChatroomState {
  ChatroomUninitialized({required chatPartner, required appUser})
      : super(chatPartner: chatPartner, appUser: appUser);

  @override
  List<Object> get props => [chatPartner, appUser];
}

class ChatroomRequested extends ChatroomState {
  final Chat chat;
  final List<ChatMessage> messages;

  ChatroomRequested(
      {required this.chat,
      required this.messages,
      required chatPartner,
      required appUser})
      : super(chatPartner: chatPartner, appUser: appUser);

  @override
  List<Object> get props => [chat, messages, chatPartner, appUser];
}

class ChatroomLoaded extends ChatroomState {
  final Chat chat;
  final List<ChatMessage> messages;

  ChatroomLoaded(
      {required this.chat,
      required this.messages,
      required chatPartner,
      required appUser})
      : super(chatPartner: chatPartner, appUser: appUser);

  @override
  List<Object> get props => [chat, messages, chatPartner, appUser];
}
