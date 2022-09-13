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

class SendChatRequestResponseButtonPressedEvent extends ChatPageEvent {
  final bool response;
  final String chatId;

  SendChatRequestResponseButtonPressedEvent(this.response, this.chatId);
}

class SendMessageEvent extends ChatPageEvent {
  final PeerPALUser chatPartner;
  final String chatId;
  final String message;
  final String type;

  SendMessageEvent(
      {required this.chatPartner,
      required this.chatId,
      required this.message,
      required this.type});
}
