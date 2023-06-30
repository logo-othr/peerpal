import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/app_logger.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/domain/usecases/get_chat_requests_for_user_usecase.dart';
import 'package:peerpal/chat/domain/usecases/get_chats_for_users_usecase.dart';
import 'package:peerpal/chat/domain/usecases/get_userchat_for_chat_usecase.dart';
import 'package:rxdart/rxdart.dart';

part 'chat_list_event.dart';

part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  GetChatsForUserUseCase _getChatsForUser;
  UserChatsForChatUseCase _getUserChatForChat;
  GetChatRequestForUserUseCase _getChatRequestForUser;
  StreamController<List<Chat>> _chatStreamController = new BehaviorSubject();
  StreamController<List<UserChat>> _userChatStreamController =
      new BehaviorSubject();
  StreamController<List<UserChat>> _userFriendRequestStreamController =
      new BehaviorSubject();

  ChatListBloc(this._getChatsForUser, this._getUserChatForChat,
      this._getChatRequestForUser)
      : super(ChatListState());

  @override
  Future<void> close() async {
    await closeStreams();
    return super.close();
  }

  Future<void> closeStreams() async {
    logger.w("Close _chatStreamController");
    await _chatStreamController.stream.drain();
    await _chatStreamController.close();
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
      Stream<List<Chat>> chatStream = _getChatsForUser();

      _chatStreamController.addStream(chatStream);

      Stream<List<UserChat>> userChatStream =
          _getUserChatForChat(_chatStreamController.stream, true);
      _userChatStreamController.addStream(userChatStream);

      Stream<List<UserChat>> chatRequestStream =
          _getChatRequestForUser(_chatStreamController.stream);
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
