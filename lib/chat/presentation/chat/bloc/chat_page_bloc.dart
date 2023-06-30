import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/message_type.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/domain/usecases/get_chat_messages_usecase.dart';
import 'package:peerpal/chat/domain/usecases/get_chats_for_users_usecase.dart';
import 'package:peerpal/chat/domain/usecases/get_userchat_for_chat_usecase.dart';
import 'package:peerpal/chat/domain/usecases/send_chat_message_usecase.dart';
import 'package:peerpal/chat/domain/usecases/send_chat_request_response_usecase.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:rxdart/rxdart.dart';

part 'chat_page_event.dart';
part 'chat_page_state.dart';

class ChatPageBloc extends Bloc<ChatPageEvent, ChatPageState> {
  GetChatsForUserUseCase _getChatsForUser;
  GetChatMessagesUseCase _getMessagesForChat;
  UserChatsForChatUseCase _getUserChatForChat;
  SendChatRequestResponseUseCase _sendChatRequestResponse;
  GetAuthenticatedUser _getAuthenticatedUser;
  SendChatMessageUseCase _sendMessage;
  String _chatPartnerId;
  AppUserRepository _appUserRepository;
  AuthenticationRepository _authenticationRepository;
  StreamController<List<ChatMessage>> _chatMessageStream =
      new BehaviorSubject();
  StreamController<List<ChatMessage>> _chatMessageStreamController =
      new BehaviorSubject();

  ChatPageBloc(
      {required getMessagesForChat,
      required getChatsForUser,
      required getUserChatForChat,
      required sendMessage,
      required sendChatRequestResponse,
      required getAuthenticatedUser,
      required appUserRepository,
      required authenticationRepository,
      required chatPartnerId})
      : this._getMessagesForChat = getMessagesForChat,
        this._getChatsForUser = getChatsForUser,
        this._getUserChatForChat = getUserChatForChat,
        this._sendMessage = sendMessage,
        this._sendChatRequestResponse = sendChatRequestResponse,
        this._getAuthenticatedUser = getAuthenticatedUser,
        this._appUserRepository = appUserRepository,
        this._authenticationRepository = authenticationRepository,
        this._chatPartnerId = chatPartnerId,
        super(ChatPageInitial());

  @override
  Future<void> close() {
    _chatMessageStream.close();
    return super.close();
  }

  Future<PeerPALUser> _getCurrentChatPartner() async {
    return _appUserRepository.getUser(_chatPartnerId);
  }

  @override
  Stream<ChatPageState> mapEventToState(ChatPageEvent event) async* {
    try {
      if (event is LoadChatPageEvent) {
        yield* _handleLoadChatPageEvent(event);
      } else if (event is SendChatRequestResponseEvent) {
        await _sendChatRequestResponse(_authenticationRepository.currentUser.id,
            _chatPartnerId, event.response, event.chatId);
      } else if (event is SendMessageEvent) {
        await _handleSendMessageEvent(event);
      } else if (event is UserChatsUpdatedEvent) {
        yield* _handleUserChatsUpdatedEvent(event);
      }
    } on Exception {
      yield ChatPageError(
          message: "Es ist ein unbekannter Fehler aufgetreten.");
    }
  }

  Stream<ChatPageState> _handleUserChatsUpdatedEvent(
      UserChatsUpdatedEvent event) async* {
    PeerPALUser chatPartner = await _getCurrentChatPartner();
    UserChat? currentChat = _findCurrentChat(event.chats);

    if (currentChat != null) {
      yield await _yieldChatLoadedState(chatPartner, currentChat);
    } else {
      yield WaitingForChatState(
          chatPartner: chatPartner, appUser: await _getAuthenticatedUser());
    }
  }

  UserChat? _findCurrentChat(List<UserChat> chats) {
    return chats.firstWhere((chat) => chat.user.id == _chatPartnerId);
  }

  Future<ChatLoadedState> _yieldChatLoadedState(
      PeerPALUser chatPartner, UserChat currentChat) async {
    Stream<List<ChatMessage>> chatMessageStream =
        _getMessagesForChat(currentChat);
    PeerPALUser appUser = await _getAuthenticatedUser();

    return ChatLoadedState(
        chatPartner: chatPartner,
        messages: chatMessageStream,
        userId: this._chatPartnerId,
        userChat: currentChat,
        appUser: appUser);
  }

  Future<void> _handleSendMessageEvent(SendMessageEvent event) async {
    if (event.payload.trim() != '') {
      await _sendMessage(
        event.chatPartner,
        event.chatId,
        event.payload,
        event.type,
      );
    }
  }


  Stream<ChatPageState> _handleLoadChatPageEvent(
      LoadChatPageEvent event) async* {
    PeerPALUser chatPartner = await _getCurrentChatPartner();

    yield ChatLoadingState(chatPartner: chatPartner);

    if (_chatIsLoaded(event.userChat)) {
      yield ChatLoadedState(
          chatPartner: chatPartner,
          messages: _loadChatMessages(event.userChat!),
          userId: this._chatPartnerId,
          userChat: event.userChat!,
          appUser: await _getAuthenticatedUser());
    } else {
      yield WaitingForChatState(
          chatPartner: chatPartner, appUser: await _getAuthenticatedUser());
      startChatListUpdateListener();
    }
  }

  Stream<List<ChatMessage>> _loadChatMessages(UserChat userChat) {
    Stream<List<ChatMessage>> _chatMessageStream =
        _getMessagesForChat(userChat);
    _chatMessageStreamController.addStream(_chatMessageStream);
    return _chatMessageStreamController.stream;
  }

  void startChatListUpdateListener() {
    Stream<List<Chat>> chatUpdatesStream = _getChatsForUser();
    Stream<List<UserChat>> userChatsUpdatesStream =
        _getUserChatForChat(chatUpdatesStream, false);
    BehaviorSubject<List<UserChat>> userChatsStreamController =
        BehaviorSubject();

    userChatsStreamController.addStream(userChatsUpdatesStream);
    userChatsStreamController.listen((updatedChats) {
      add(UserChatsUpdatedEvent(updatedChats));
    });
  }

  bool _chatIsLoaded(UserChat? userChat) {
    return userChat != null;
  }
}
