import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/domain/usecases/get_chat_requests_for_user.dart';
import 'package:peerpal/chat/domain/usecases/get_chats_for_users.dart';
import 'package:rxdart/rxdart.dart';

part 'chat_request_list_event.dart';
part 'chat_request_list_state.dart';

class ChatRequestListBloc extends Bloc<ChatRequestListEvent, ChatRequestListState> {
  GetChatsForUser _getChatsForUser;
  GetChatRequestForUser _getChatRequestForUser;
  StreamController<List<Chat>> _chatStreamController = new BehaviorSubject();
  StreamController<List<UserChat>> _userFriendRequestStreamController = new BehaviorSubject();
  ChatRequestListBloc(this._getChatsForUser, this._getChatRequestForUser) : super(ChatRequestListState());

  @override
  Future<void> close() {
    // ToDo: Check for memory leaks
   // _chatStreamController.close();
   // _userFriendRequestStreamController.close();
    return super.close();
  }

  @override
  Stream<ChatRequestListState> mapEventToState(ChatRequestListEvent event) async* {
    if (event is ChatRequestListLoaded) {
      Stream<List<Chat>> chatStream = _getChatsForUser();
      _chatStreamController.addStream(chatStream);

      Stream<List<UserChat>> chatRequestStream = _getChatRequestForUser(_chatStreamController.stream);
      _userFriendRequestStreamController.addStream(chatRequestStream);

      yield state.copyWith(
          status: ChatRequestListStatus.success,
          chatRequests: _userFriendRequestStreamController.stream
      );
    }

  }
}