part of 'chat_page_bloc.dart';

@immutable
abstract class ChatPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadChatPageEvent extends ChatPageEvent {
  final UserChat? userChat;

  LoadChatPageEvent(this.userChat);
}

class SendChatRequestResponseEvent extends ChatPageEvent {
  final bool response;
  final String chatId;

  SendChatRequestResponseEvent(this.response, this.chatId);
}

class ChatListUpdatedEvent extends ChatPageEvent {
  final List<UserChat> chats;

  ChatListUpdatedEvent(this.chats);
}

class SendMessageEvent extends ChatPageEvent {
  final PeerPALUser chatPartner;
  final String? chatId;
  final String payload;
  final MessageType type;

  SendMessageEvent(
      {required this.chatPartner,
      required this.chatId,
      required this.payload,
      required this.type});
}
