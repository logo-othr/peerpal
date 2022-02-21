import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/domain/usecases/get_chat_requests_for_user.dart';
import 'package:peerpal/chat/domain/usecases/get_chats_for_users.dart';
import 'package:peerpal/chat/domain/usecases/get_messages_for_chat.dart';
import 'package:peerpal/chat/domain/usecases/get_userchat_for_chat.dart';
import 'package:peerpal/chat/domain/usecases/send_chat_message.dart';
import 'package:peerpal/chat/domain/usecases/send_chat_request_response.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';
import 'package:rxdart/rxdart.dart';

part 'chat_page_event.dart';

part 'chat_page_state.dart';

class ChatPageBloc extends Bloc<ChatPageEvent, ChatPageState> {
  GetChatsForUser getChatsForUser;
  GetMessagesForChat getMessagesForChat;
  GetUserChatForChat getUserChatForChat;
  SendChatRequestResponse sendChatRequestResponse;
  SendChatMessage sendMessage;
  String chatPartnerId;
  AppUserRepository appUserRepository;
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
      required this.appUserRepository,
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
        PeerPALUser chatPartner =
        await appUserRepository.getUserInformation(chatPartnerId);
        yield ChatPageLoading(chatPartner: chatPartner);
        if (event.userChat == null) {
          // ToDo: Use streamcontroller
          yield ChatPageChatNotExists(chatPartner: chatPartner);
          Stream<List<Chat>> chatStream = getChatsForUser();
          Stream<List<UserChat>> userChatStream = getUserChatForChat(chatStream, false);

          await for (List<UserChat> chats in userChatStream) {
            UserChat? currentChat = null;
            for (UserChat chat in chats) {
              if (chat.user.id == chatPartnerId) currentChat = chat;
            }
            if (currentChat != null) {
              Stream<List<ChatMessage>> _chatMessageStream =
              getMessagesForChat(currentChat);
              // _chatMessageStreamController.addStream(_chatMessageStream);

              yield ChatPageChatExists(
                  chatPartner: chatPartner,
                  messages: _chatMessageStream,
                  // _chatMessageStreamController.stream,
                  userId: this.chatPartnerId,
                  userChat: currentChat,
                  appUser: await appUserRepository.getCurrentUserInformation());
            }
          }
        } else {
          Stream<List<ChatMessage>> _chatMessageStream =
          getMessagesForChat(event.userChat!);
          _chatMessageStreamController.addStream(_chatMessageStream);

          yield ChatPageChatExists(
              chatPartner: chatPartner,
              messages: _chatMessageStreamController.stream,
              userId: this.chatPartnerId,
              userChat: event.userChat!,
              appUser: await appUserRepository.getCurrentUserInformation());
        }
      } else if(event is SendChatRequestResponseButtonPressed) {

        await sendChatRequestResponse(appUserRepository.currentUser.id, chatPartnerId, event.response);
      }

    } on Exception {
      yield ChatPageError(message: "Fehler beim laden des Chats");
    }
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
