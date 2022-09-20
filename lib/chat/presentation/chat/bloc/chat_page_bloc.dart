import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/message_type.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/domain/usecases/get_chats_for_users.dart';
import 'package:peerpal/chat/domain/usecases/get_messages_for_chat.dart';
import 'package:peerpal/chat/domain/usecases/get_userchat_for_chat.dart';
import 'package:peerpal/chat/domain/usecases/send_chat_message.dart';
import 'package:peerpal/chat/domain/usecases/send_chat_request_response.dart';
import 'package:peerpal/peerpal_user/data/repository/app_user_repository.dart';
import 'package:peerpal/peerpal_user/domain/peerpal_user.dart';
import 'package:peerpal/peerpal_user/domain/usecase/get_user_usecase.dart';
import 'package:rxdart/rxdart.dart';

part 'chat_page_event.dart';
part 'chat_page_state.dart';

class ChatPageBloc extends Bloc<ChatPageEvent, ChatPageState> {
  GetChatsForUser _getChatsForUser;
  GetMessagesForChat _getMessagesForChat;
  GetUserChatForChat _getUserChatForChat;
  SendChatRequestResponse _sendChatRequestResponse;
  GetAuthenticatedUser _getAuthenticatedUser;
  SendChatMessage _sendMessage;
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

  @override
  Stream<ChatPageState> mapEventToState(ChatPageEvent event) async* {
    try {
      if (event is LoadChatPageEvent) {
        yield* _handleLoadChatPageEvent(event);
      } else if (event is SendChatRequestResponseButtonPressedEvent) {
        await _sendChatRequestResponse(_authenticationRepository.currentUser.id,
            _chatPartnerId, event.response, event.chatId);
      } else if (event is SendMessageEvent) {
        await _handleSendMessageEvent(event);
      } else if (event is UploadImageEvent) {
        yield* _handleUploadImageEvent(event);
      }
    } on Exception {
      yield ChatPageError(
          message: "Es ist ein unbekannter Fehler aufgetreten.");
    }
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

  Stream<ChatPageState> _handleUploadImageEvent(UploadImageEvent event) async* {
    ChatPageState currentState = state;
    PeerPALUser chatPartner =
        await _appUserRepository.getUserInformation(_chatPartnerId);
    yield ChatLoadingState(chatPartner: chatPartner);
    if (_chatIsLoaded(event.userChat)) {
      yield ChatLoadedState(
          chatPartner: chatPartner,
          messages: _loadChatMessages(event.userChat!),
          userId: this._chatPartnerId,
          userChat: event.userChat!,
          appUser: await _getAuthenticatedUser());
    } else {
      yield WaitingForChatOrFirstMessage(
          chatPartner: chatPartner, appUser: await _getAuthenticatedUser());
      yield* _yieldChatLoadedStateWhenChatIsLoaded(chatPartner);
    }
  }

  Stream<ChatPageState> _handleLoadChatPageEvent(
      LoadChatPageEvent event) async* {
    PeerPALUser chatPartner =
        await _appUserRepository.getUserInformation(_chatPartnerId);
    yield ChatLoadingState(chatPartner: chatPartner);
    if (_chatIsLoaded(event.userChat)) {
      yield ChatLoadedState(
          chatPartner: chatPartner,
          messages: _loadChatMessages(event.userChat!),
          userId: this._chatPartnerId,
          userChat: event.userChat!,
          appUser: await _getAuthenticatedUser());
    } else {
      yield WaitingForChatOrFirstMessage(
          chatPartner: chatPartner, appUser: await _getAuthenticatedUser());
      yield* _yieldChatLoadedStateWhenChatIsLoaded(chatPartner);
    }
  }

  Stream<List<ChatMessage>> _loadChatMessages(UserChat userChat) {
    Stream<List<ChatMessage>> _chatMessageStream =
        _getMessagesForChat(userChat);
    _chatMessageStreamController.addStream(_chatMessageStream);
    return _chatMessageStreamController.stream;
  }

  Stream<ChatLoadedState> _yieldChatLoadedStateWhenChatIsLoaded(
      PeerPALUser chatPartner) async* {
    Stream<List<Chat>> chatStream =
    _getChatsForUser(); // ToDo: Use streamcontroller
    Stream<List<UserChat>> userChatStream =
    _getUserChatForChat(chatStream, false);
    await for (List<UserChat> chats in userChatStream) {
      UserChat? currentChat = null;
      for (UserChat chat in chats) {
        if (chat.user.id == _chatPartnerId) currentChat = chat;
      }
      if (currentChat != null) {
        Stream<List<ChatMessage>> _chatMessageStream =
            _getMessagesForChat(currentChat);
        yield ChatLoadedState(
            chatPartner: chatPartner,
            messages: _chatMessageStream,
            userId: this._chatPartnerId,
            userChat: currentChat,
            appUser: await _getAuthenticatedUser());
      }
    }
  }

  bool _chatIsLoaded(UserChat? userChat) {
    return userChat != null;
  }
}
