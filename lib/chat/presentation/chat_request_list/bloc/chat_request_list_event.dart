part of 'chat_request_list_bloc.dart';

@immutable
abstract class ChatRequestListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ChatRequestListLoaded extends ChatRequestListEvent {}
