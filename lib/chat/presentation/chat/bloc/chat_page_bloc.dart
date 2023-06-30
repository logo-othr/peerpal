import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/message_type.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/domain/usecases/chat_to_userchat_usecase.dart';
import 'package:peerpal/chat/domain/usecases/get_chat_messages_usecase.dart';
import 'package:peerpal/chat/domain/usecases/get_chats_usecase.dart';
import 'package:peerpal/chat/domain/usecases/send_chat_message_usecase.dart';
import 'package:peerpal/chat/domain/usecases/send_chat_request_response_usecase.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:rxdart/rxdart.dart';

part 'chat_page_event.dart';
part 'chat_page_state.dart';

class ChatPageBloc extends Bloc<ChatPageEvent, ChatPageState> {
  GetChatsUseCase _getChatsForUser;
  GetChatMessagesUseCase _getMessagesForChat;
  ChatToUserChatUseCase _getUserChatForChat;
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

  late final ChatPageHandler _chatPageHandler;
  late final SendMessageHandler _sendMessageHandler;

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
        super(ChatPageInitial()) {
    this._chatPageHandler = ChatPageHandler(
        addEventToBloc: add,
        chatMessageStreamController: _chatMessageStreamController);

    this._sendMessageHandler =
        SendMessageHandler(sendChatMessageUseCase: _sendMessage);
  }

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
        yield* _chatPageHandler.handle(
            event,
            _getCurrentChatPartner,
            _getMessagesForChat,
            _getAuthenticatedUser,
            _getChatsForUser,
            _getUserChatForChat,
            _chatPartnerId);
      } else if (event is SendChatRequestResponseEvent) {
        await _sendChatRequestResponse(_authenticationRepository.currentUser.id,
            _chatPartnerId, event.response, event.chatId);
      } else if (event is SendMessageEvent) {
        yield* _sendMessageHandler.handle(event);
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
}

class SendMessageHandler {
  SendChatMessageUseCase _sendMessage;

  SendMessageHandler({required SendChatMessageUseCase sendChatMessageUseCase})
      : this._sendMessage = sendChatMessageUseCase;

  Stream<ChatPageState> handle(
    SendMessageEvent event,
  ) async* {
    if (event.payload.trim() != '') {
      await _sendMessage(
        event.chatPartner,
        event.chatId,
        event.payload,
        event.type,
      );
    }
  }
}

class ChatPageHandler {
  final Function(ChatPageEvent) addEventToBloc;
  final StreamController<List<ChatMessage>> chatMessageStreamController;

  ChatPageHandler(
      {required this.addEventToBloc,
      required this.chatMessageStreamController});

  Stream<ChatPageState> handle(
      LoadChatPageEvent event,
      Future<PeerPALUser> Function() getCurrentChatPartner,
      GetChatMessagesUseCase getMessagesForChat,
      GetAuthenticatedUser getAuthenticatedUser,
      GetChatsUseCase getChatsForUser,
      ChatToUserChatUseCase getUserChatForChat,
      String chatPartnerId) async* {
    PeerPALUser chatPartner = await getCurrentChatPartner();

    yield ChatLoadingState(chatPartner: chatPartner);

    if (_chatIsLoaded(event.userChat)) {
      yield ChatLoadedState(
          chatPartner: chatPartner,
          messages: _loadChatMessages(event.userChat!, getMessagesForChat),
          userId: chatPartnerId,
          userChat: event.userChat!,
          appUser: await getAuthenticatedUser());
    } else {
      yield WaitingForChatState(
          chatPartner: chatPartner, appUser: await getAuthenticatedUser());
      startChatListUpdateListener(getChatsForUser, getUserChatForChat);
    }
  }

  Stream<List<ChatMessage>> _loadChatMessages(
      UserChat userChat, Function(UserChat) getMessagesForChat) {
    Stream<List<ChatMessage>> chatMessageStream = getMessagesForChat(userChat);
    chatMessageStreamController.addStream(chatMessageStream);
    return chatMessageStreamController.stream;
  }

  void startChatListUpdateListener(Function() getChatsForUser,
      Function(Stream<List<Chat>>, bool) getUserChatForChat) {
    Stream<List<Chat>> chatUpdatesStream = getChatsForUser();
    Stream<List<UserChat>> userChatsUpdatesStream =
        getUserChatForChat(chatUpdatesStream, false);
    BehaviorSubject<List<UserChat>> userChatsStreamController =
        BehaviorSubject();

    userChatsStreamController.addStream(userChatsUpdatesStream);
    userChatsStreamController.listen((updatedChats) {
      addEventToBloc(UserChatsUpdatedEvent(updatedChats));
    });
  }

  bool _chatIsLoaded(UserChat? userChat) {
    return userChat != null;
  }
}
