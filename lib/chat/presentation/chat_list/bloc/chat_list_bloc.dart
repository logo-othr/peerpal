import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/app_logger.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/domain/usecases/get_chat_requests_usecase.dart';
import 'package:peerpal/chat/domain/usecases/get_users_chats.dart';
import 'package:rxdart/rxdart.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  GetChatRequestsUseCase _getChatRequestForUser;
  StreamController<List<UserChat>> _userChatStreamController =
      new BehaviorSubject();
  StreamController<List<UserChat>> _userFriendRequestStreamController =
      new BehaviorSubject();
  GetUsersChats _getChats;

  ChatListBloc(this._getChats, this._getChatRequestForUser)
      : super(ChatListState());

  @override
  Future<void> close() async {
    await closeStreams();
    return super.close();
  }

  Future<void> closeStreams() async {
    logger.w("Close _userChatStreamController");
    await _userChatStreamController.stream.drain();
    await _userChatStreamController.close();
    logger.w("Close _userFriendRequestStreamController");
    await _userFriendRequestStreamController.stream.drain();
    await _userFriendRequestStreamController.close();
  }

  var chatStreamSubscription;

  @override
  Stream<ChatListState> mapEventToState(ChatListEvent event) async* {
    if (event is ChatListLoaded) {
      Stream<List<UserChat>> userChatStream = _getChats(true);
      _userChatStreamController.addStream(userChatStream);

      Stream<List<UserChat>> chatRequestStream =
          _getChatRequestForUser(_userChatStreamController.stream);
      _userFriendRequestStreamController.addStream(chatRequestStream);

      yield state.copyWith(
          status: ChatListStatus.success,
          chats: _userChatStreamController.stream,
          chatRequests: _userFriendRequestStreamController.stream);
    } else if (event is ChatClickEvent) {
      Map<String, String> lastClicked = {};
      lastClicked.addAll(state.lastClicked);
      lastClicked[event.userChat.chat.chatId] =
          event.userChat.chat.lastMessage?.timestamp ?? "0";

      /* List<UserChat> userChats = await _userChatStreamController.;
      for (int i = 0; i < userChats.length; i++) {
        if (userChats[i].chat.chatId == event.userChat.chat.chatId) {
          userChats[i] = UserChat(
              chat: event.userChat.chat,
              user: event.userChat.user,
              redDot: false);
        }
      }
      _userChatStreamController.sink.add(userChats);*/
      yield state.copyWith(
        status: ChatListStatus.chatClicked,
        lastClicked: lastClicked,
      );
    } else if (event is ChatClickedEvent) {
      /*  List<UserChat> updatedList = [];
      for(UserChat userChat in event.userChats) {
        updatedList.add(userChat.copyWith(redDot: false, user: null));
      }
      _userChatStreamController.sink.add(updatedList);
      yield state.copyWith(
        status: ChatListStatus.success,);*/
    } else if (event is ChatListStreamUpdate) {
      Map<String, String> redDot = {};
      for (UserChat userChat in event.userChats) {
        redDot[userChat.chat.chatId] =
            userChat.chat.lastMessage?.timestamp ?? "0";
      }
      yield state.copyWith(
        status: ChatListStatus.streamUpdated,
        redDot: redDot,
      );
    }
  }
}
