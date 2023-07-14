import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/chat/domain/message_type.dart';
import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/domain/usecases/get_chat_messages_usecase.dart';
import 'package:peerpal/chat/domain/usecases/get_users_chats.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:rxdart/rxdart.dart';

part 'chat_page_event.dart';
part 'chat_page_state.dart';

class ChatPageBloc extends Bloc<ChatPageEvent, ChatPageState> {
  GetChatMessagesUseCase _getMessagesForChatUseCase;

  GetAuthenticatedUser _getAuthenticatedUser;
  String _chatPartnerId;
  AppUserRepository _appUserRepository;
  StreamController<List<ChatMessage>> _chatMessageStreamController =
      new BehaviorSubject();
  GetUsersChats _getChats;
  late final LoadChatPageHandler _loadChatPageHandler;
  late final UserChatsUpdatedHandler _userChatsUpdateHandler;

  ChatPageBloc(
      {required getMessagesForChatUseCase,
      required getChats,
      required getAuthenticatedUser,
      required appUserRepository,
      required authenticationRepository,
      required chatPartnerId})
      : this._getMessagesForChatUseCase = getMessagesForChatUseCase,
        this._getChats = getChats,
        this._getAuthenticatedUser = getAuthenticatedUser,
        this._appUserRepository = appUserRepository,
        this._chatPartnerId = chatPartnerId,
        super(ChatPageInitial()) {
    this._loadChatPageHandler = LoadChatPageHandler(
      addEventToBloc: add,
      chatMessageStreamController: _chatMessageStreamController,
      getCurrentChatPartner: _getCurrentChatPartner,
      getMessagesForChat: _getMessagesForChatUseCase,
      getAuthenticatedUser: _getAuthenticatedUser,
      chatPartnerId: _chatPartnerId,
      getChats: _getChats,
    );

    this._userChatsUpdateHandler = UserChatsUpdatedHandler(
        getCurrentChatPartner: _getCurrentChatPartner,
        getChatMessagesUseCase: _getMessagesForChatUseCase,
        getAuthenticatedUser: getAuthenticatedUser,
        chatPartnerId: _chatPartnerId);
  }

  @override
  Future<void> close() {
    _chatMessageStreamController.close();
    return super.close();
  }

  Future<PeerPALUser> _getCurrentChatPartner() async {
    return await _appUserRepository.getUser(_chatPartnerId);
  }

  @override
  Stream<ChatPageState> mapEventToState(ChatPageEvent event) async* {
    try {
      if (event is LoadChatPageEvent) {
        yield* _loadChatPageHandler.handle(event);
      } else if (event is ChatListUpdatedEvent) {
        yield* _userChatsUpdateHandler.handle(event);
      }
    } on Exception {
      yield ChatPageError(
          message: "Es ist ein unbekannter Fehler aufgetreten.");
    }
  }
}

class UserChatsUpdatedHandler {
  Future<PeerPALUser> Function() _getCurrentChatPartner;
  GetChatMessagesUseCase _getChatMessagesUseCase;
  String _chatPartnerId;
  GetAuthenticatedUser _getAuthenticatedUser;

  UserChatsUpdatedHandler({
    required Future<PeerPALUser> Function() getCurrentChatPartner,
    required GetChatMessagesUseCase getChatMessagesUseCase,
    required GetAuthenticatedUser getAuthenticatedUser,
    required String chatPartnerId,
  })  : this._getCurrentChatPartner = getCurrentChatPartner,
        this._getChatMessagesUseCase = getChatMessagesUseCase,
        this._getAuthenticatedUser = getAuthenticatedUser,
        this._chatPartnerId = chatPartnerId {}

  Stream<ChatPageState> handle(ChatListUpdatedEvent event) async* {
    PeerPALUser chatPartner = await _getCurrentChatPartner();
    UserChat? currentChat = event.chats
        .firstWhere((chat) => chat.user.id == _chatPartnerId, orElse: null);

    if (currentChat != null) {
      Stream<List<ChatMessage>> chatMessageStream =
          _getChatMessagesUseCase(currentChat);
      PeerPALUser appUser = await _getAuthenticatedUser();

      yield ChatLoadedState(
          chatPartner: chatPartner,
          messages: chatMessageStream,
          userId: this._chatPartnerId,
          userChat: currentChat,
          appUser: appUser);
    } else {
      yield WaitingForChatState(
          chatPartner: chatPartner, appUser: await _getAuthenticatedUser());
    }
  }
}

class LoadChatPageHandler {
  final Function(ChatPageEvent) addEventToBloc;
  final StreamController<List<ChatMessage>> chatMessageStreamController;

  final Future<PeerPALUser> Function() getCurrentChatPartner;
  final GetChatMessagesUseCase getMessagesForChat;
  final GetAuthenticatedUser getAuthenticatedUser;
  final GetUsersChats getChats;
  final String chatPartnerId;

  LoadChatPageHandler({
    required this.addEventToBloc,
    required this.chatMessageStreamController,
    required this.getCurrentChatPartner,
    required this.getMessagesForChat,
    required this.getAuthenticatedUser,
    required this.getChats,
    required this.chatPartnerId,
  });

  Stream<ChatPageState> handle(LoadChatPageEvent event) async* {
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
      startChatListUpdateListener(getChats);
    }
  }

  Stream<List<ChatMessage>> _loadChatMessages(
      UserChat userChat, Function(UserChat) getMessagesForChat) {
    Stream<List<ChatMessage>> chatMessageStream = getMessagesForChat(userChat);
    chatMessageStreamController.addStream(chatMessageStream);
    return chatMessageStreamController.stream;
  }

  void startChatListUpdateListener(GetUsersChats getChats) {
    Stream<List<UserChat>> userChatsUpdatesStream = getChats(false);
    BehaviorSubject<List<UserChat>> userChatsStreamController =
        BehaviorSubject();

    userChatsStreamController.addStream(userChatsUpdatesStream);
    userChatsStreamController.listen((updatedChats) {
      addEventToBloc(ChatListUpdatedEvent(updatedChats));
    });
  }

  bool _chatIsLoaded(UserChat? userChat) {
    return userChat != null;
  }
}
