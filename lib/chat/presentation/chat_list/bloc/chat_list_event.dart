part of 'chat_list_bloc.dart';

@immutable
abstract class ChatListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ChatListLoaded extends ChatListEvent {}
