import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/chatv2/domain/core-usecases/send_chat_request_response.dart';
import 'package:peerpal/chatv2/domain/enums/message_type.dart';
import 'package:peerpal/chatv2/domain/models/chat.dart';
import 'package:peerpal/chatv2/domain/models/chat_message.dart';
import 'package:peerpal/chatv2/domain/usecases/get_chats.dart';
import 'package:peerpal/chatv2/domain/usecases/get_messages.dart';
import 'package:peerpal/chatv2/domain/usecases/get_user.dart';
import 'package:peerpal/chatv2/domain/usecases/send_message.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';

part 'chatroom_state.dart';

class ChatroomCubit extends Cubit<ChatroomState> {
  final GetChats _getChats;
  final GetAuthenticatedUser _getAppUser;
  final GetUser _getUser;
  final GetMessages _getMessages;
  final SendMessage _sendMessage;
  final SendChatRequestResponse _sendChatRequestResponse;

  late final StreamSubscription? _messageStream;
  late final StreamSubscription? _chatsStream;

  ChatroomCubit({required GetChats getChats,
    required GetAuthenticatedUser getAppUser,
    required GetUser getUser,
    required GetMessages getMessages,
    required SendMessage sendMessage,
    required SendChatRequestResponse sendChatRequestResponse})
      : this._getChats = getChats,
        this._getAppUser = getAppUser,
        this._getUser = getUser,
        this._getMessages = getMessages,
        this._sendMessage = sendMessage,
        this._sendChatRequestResponse = sendChatRequestResponse,
        super(ChatroomInitial(
            chatPartner: PeerPALUser.empty, appUser: PeerPALUser.empty));

  Future<void> loadChatroom(String? chatPartnerId) async {
    // Return if the page is already initialized
    if (!(state is ChatroomInitial)) return;

    PeerPALUser appUser = (await _getAppUser());
    PeerPALUser chatPartner = (await _getUser(
        chatPartnerId!)); // TODO: Throw exception if no user is found
    emit(ChatroomLoading(chatPartner: chatPartner, appUser: appUser));

    // Listen to all the user's chats.
    // In this way, we can react to changes such as
    // if the chat no longer exists
    _chatsStream = _getChats(state.appUser.id!).listen(_onChatsUpdate);
  }

  _onChatsUpdate(List<Chat> chats) async {
    Chat? chat = chats.firstWhereOrNull((Chat chat) => _chatExists(chat));

    if (chat == null) {
      _setChatUninitializedState();
    } else {
      emit(ChatroomLoaded(
        messages: [],
        chatPartner: state.chatPartner,
        chat: chat,
        appUser: state.appUser,
      ));
      _messageStream = _getMessages(chat.chatId).listen(_onMessagesUpdate);
    }
  }

  bool isChatRequest() {
    ChatroomLoaded loadedState = state as ChatroomLoaded;
    Chat chat = loadedState.chat;
    bool chatNotStartedByUser = chat.startedBy != state.appUser.id;
    bool chatNotAccepted = !chat.chatRequestAccepted;
    return (chatNotStartedByUser && chatNotAccepted);
  }

  Future<void> sendChatRequestResponse(bool response) async {
    ChatroomLoaded loadedState = state as ChatroomLoaded;
    Chat chat = loadedState.chat;
    String chatPartnerId = loadedState.chatPartner.id!;
    await _sendChatRequestResponse(chatPartnerId, chat.chatId, response);
  }

  bool _chatExists(Chat chat) {
    return chat.uids.contains(state.appUser.id) &&
        chat.uids.contains(state.chatPartner.id);
  }

  _setChatUninitializedState() {
    emit(ChatroomUninitialized(
        appUser: state.appUser, chatPartner: state.chatPartner));
  }

  _onMessagesUpdate(List<ChatMessage> messages) {
    ChatroomLoaded loadedState = state as ChatroomLoaded;
    emit(ChatroomLoaded(
      messages: messages,
      chatPartner: loadedState.chatPartner,
      chat: loadedState.chat,
      appUser: loadedState.appUser,
    ));
  }

  Future<void> sendMessage(String text, MessageType messageType) async {
    if (state is ChatroomUninitialized) {
      await _sendMessage(state.appUser.id!, null, text, MessageType.text);
    } else if (state is ChatroomLoaded) {
      await _sendMessage(state.appUser.id!,
          (state as ChatroomLoaded).chat.chatId, text, MessageType.text);
    }
  }

  @override
  Future<void> close() async {
    await _messageStream?.cancel();
    await _chatsStream?.cancel();
    return super.close();
  }
}
