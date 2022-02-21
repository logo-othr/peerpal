import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/domain/usecases/get_chat_requests_for_user.dart';
import 'package:peerpal/chat/domain/usecases/get_chats_for_users.dart';
import 'package:peerpal/chat/domain/usecases/get_userchat_for_chat.dart';
import 'package:rxdart/rxdart.dart';

part 'chat_list_event.dart';

part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  GetChatsForUser _getChatsForUser;
  GetUserChatForChat _getUserChatForChat;
  GetChatRequestForUser _getChatRequestForUser;
  StreamController<List<Chat>> _chatStreamController = new BehaviorSubject();
  StreamController<List<UserChat>> _userChatStreamController = new BehaviorSubject();
  StreamController<List<UserChat>> _userFriendRequestStreamController = new BehaviorSubject();
  ChatListBloc(this._getChatsForUser, this._getUserChatForChat, this._getChatRequestForUser) : super(ChatListState());

  @override
  Future<void> close() {
   _userChatStreamController.close();
    return super.close();
  }

  @override
  Stream<ChatListState> mapEventToState(ChatListEvent event) async* {
      if (event is ChatListLoaded) {
        Stream<List<Chat>> chatStream = _getChatsForUser();
        _chatStreamController.addStream(chatStream);

        Stream<List<UserChat>> userChatStream = _getUserChatForChat(_chatStreamController.stream, true);
        _userChatStreamController.addStream(userChatStream);

        Stream<List<UserChat>> chatRequestStream = _getChatRequestForUser(_chatStreamController.stream);
        _userFriendRequestStreamController.addStream(chatRequestStream);

        yield state.copyWith(
          status: ChatListStatus.success,
          chats: _userChatStreamController.stream,
          chatRequests: _userFriendRequestStreamController.stream
        );
      }

  }
}