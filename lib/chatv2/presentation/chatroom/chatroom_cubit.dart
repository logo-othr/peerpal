import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/chat/presentation/chat/chat_loading/cubit/chat_page_cubit.dart';
import 'package:peerpal/chatv2/domain/models/chat.dart';
import 'package:peerpal/chatv2/domain/models/chat_message.dart';
import 'package:peerpal/chatv2/domain/usecases/get_chats.dart';
import 'package:peerpal/chatv2/domain/usecases/get_messages.dart';
import 'package:peerpal/chatv2/domain/usecases/get_user.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';

part 'chatroom_state.dart';

class ChatroomCubit extends Cubit<ChatroomState> {
  final GetChats getChats;
  final GetAuthenticatedUser getAppUser;
  final GetUser getUser;
  final GetMessages getMessages;

  late final StreamSubscription? _messageStream;
  late final StreamSubscription? _chatsStream;

  ChatroomCubit(
      {required this.getChats,
      required this.getAppUser,
      required this.getUser,
      required this.getMessages})
      : super(ChatroomInitial(
            chatPartner: PeerPALUser.empty, appUser: PeerPALUser.empty));

  Future<void> loadChatroom(String? chatPartnerId) async {
    // Return if the page is already initialized
    if (!(state is ChatPageInitial)) return;

    var appUser = (await getAppUser());
    var chatPartner = (await getUser(
        chatPartnerId!)); // TODO: Throw exception if no user is found
    emit(ChatroomLoading(chatPartner: chatPartner, appUser: appUser));

    // Listen to all the user's chats.
    // In this way, we can react to changes such as
    // if the chat no longer exists
    _chatsStream = getChats(state.appUser.id!).listen(_onChatsUpdate);
  }

  _onChatsUpdate(chats) async {
    Chat? chat = chats.firstWhereOrNull((Chat chat) => _chatExists(chat));

    if (chat == null) {
      _setChatUninitializedState();
    } else {
      emit(ChatLoaded(
        messages: [],
        chatPartner: state.chatPartner,
        chat: chat,
        appUser: state.appUser,
      ));
      _messageStream = getMessages(chat.chatId).listen(_onMessagesUpdate);
    }
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
    ChatLoaded loadedState = state as ChatLoaded;
    emit(ChatLoaded(
      messages: messages,
      chatPartner: loadedState.chatPartner,
      chat: loadedState.chat,
      appUser: loadedState.appUser,
    ));
  }

  @override
  Future<void> close() async {
    await _messageStream?.cancel();
    await _chatsStream?.cancel();
    return super.close();
  }
}
