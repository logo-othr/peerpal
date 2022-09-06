import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
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
  GetChatsForUser getChatsForUser;
  GetMessagesForChat getMessagesForChat;
  GetUserChatForChat getUserChatForChat;
  SendChatRequestResponse sendChatRequestResponse;
  GetAuthenticatedUser getAuthenticatedUser;
  SendChatMessage sendMessage;
  String chatPartnerId;
  AppUserRepository appUserRepository;
  AuthenticationRepository authenticationRepository;
  StreamController<List<ChatMessage>> _chatMessageStream =
      new BehaviorSubject();
  StreamController<List<ChatMessage>> _chatMessageStreamController =
      new BehaviorSubject();

  ChatPageBloc(
      {required this.getMessagesForChat,
      required this.getChatsForUser,
      required this.getUserChatForChat,
      required this.sendMessage,
      required this.sendChatRequestResponse,
      required this.getAuthenticatedUser,
      required this.appUserRepository,
      required this.authenticationRepository,
      required this.chatPartnerId})
      : super(ChatPageInitial());

  @override
  Future<void> close() {
    _chatMessageStream.close();
    return super.close();
  }

  @override
  Stream<ChatPageState> mapEventToState(ChatPageEvent event) async* {
    try {
      if (event is LoadChatPage) {
        yield* handleLoadChatPageEvent(event);
      } else if (event is SendChatRequestResponseButtonPressed) {
        await sendChatRequestResponse(authenticationRepository.currentUser.id,
            chatPartnerId, event.response, event.chatId);
      }
    } on Exception {
      yield ChatPageError(message: "Fehler beim laden des Chats");
    }
  }

  Stream<ChatPageState> handleLoadChatPageEvent(LoadChatPage event) async* {
    PeerPALUser chatPartner =
        await appUserRepository.getUserInformation(chatPartnerId);
    yield ChatPageLoading(chatPartner: chatPartner);
    if (_chatIsLoaded(event.userChat)) {
      yield ChatLoaded(
          chatPartner: chatPartner,
          messages: _loadChatMessages(event.userChat!),
          userId: this.chatPartnerId,
          userChat: event.userChat!,
          appUser: await getAuthenticatedUser());
    } else {
      yield WaitingForChatOrFirstMessage(
          chatPartner: chatPartner, appUser: await getAuthenticatedUser());
      yield* _yieldChatLoadedStateWhenChatIsLoaded(chatPartner);
    }
  }

  Stream<List<ChatMessage>> _loadChatMessages(UserChat userChat) {
    Stream<List<ChatMessage>> _chatMessageStream = getMessagesForChat(userChat);
    _chatMessageStreamController.addStream(_chatMessageStream);
    return _chatMessageStreamController.stream;
  }

  Stream<ChatLoaded> _yieldChatLoadedStateWhenChatIsLoaded(
      PeerPALUser chatPartner) async* {
    Stream<List<Chat>> chatStream =
        getChatsForUser(); // ToDo: Use streamcontroller
    Stream<List<UserChat>> userChatStream =
        getUserChatForChat(chatStream, false);
    await for (List<UserChat> chats in userChatStream) {
      UserChat? currentChat = null;
      for (UserChat chat in chats) {
        if (chat.user.id == chatPartnerId) currentChat = chat;
      }
      if (currentChat != null) {
        Stream<List<ChatMessage>> _chatMessageStream =
            getMessagesForChat(currentChat);
        yield ChatLoaded(
            chatPartner: chatPartner,
            messages: _chatMessageStream,
            userId: this.chatPartnerId,
            userChat: currentChat,
            appUser: await getAuthenticatedUser());
      }
    }
  }

  bool _chatIsLoaded(UserChat? userChat) {
    return userChat != null;
  }

  Future<void> sendChatMessage(
    PeerPALUser userInformation,
    String? chatId,
    String content,
    String type,
  ) async {
    await sendMessage(
      userInformation,
      chatId,
      content,
      type,
    );
  }
}
