/*part of 'chat_list_bloc.dart';

@immutable
abstract class ChatListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ChatListLoaded extends ChatListEvent {}

class ChatClickEvent extends ChatListEvent {
  final UserChat userChat;

  ChatClickEvent(this.userChat);
}

class ChatClickedEvent extends ChatListEvent {
  final List<UserChat> userChats;

  ChatClickedEvent(this.userChats);
}

class ChatListStreamUpdate extends ChatListEvent {
  final List<UserChat> userChats;

  ChatListStreamUpdate(this.userChats);
}
*/
