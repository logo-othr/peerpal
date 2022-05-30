part of 'chat_page_bloc.dart';

@immutable
abstract class ChatPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadChatPage extends ChatPageEvent {
  final UserChat? userChat;

  LoadChatPage(this.userChat);
}

class SendChatRequestResponseButtonPressed extends ChatPageEvent {
  final bool response;
  final String chatId;

  SendChatRequestResponseButtonPressed(this.response, this.chatId);
}
