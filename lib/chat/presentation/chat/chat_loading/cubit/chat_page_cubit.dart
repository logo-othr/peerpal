import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/chat/domain/message_type.dart';
import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/chat/domain/models/user_chat.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecases/get_all_userchats.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';

part 'chat_page_state.dart';

class ChatPageCubit extends Cubit<ChatPageState> {
  ChatRepository chatRepository;
  GetAllUserChats getAllUserChats;
  GetAuthenticatedUser getAuthenticatedUser;
  AppUserRepository appUserRepository;

  ChatPageCubit(
      {required this.appUserRepository,
      required this.chatRepository,
      required this.getAuthenticatedUser,
      required this.getAllUserChats,
      required chatPartnerId})
      : super(ChatPageInitial(chatPartnerId: chatPartnerId));

  void loadChat() async {
    if (state is ChatPageInitial) {
      UserChat? currentChat = (state as ChatPageInitial).currentChat;
      emit(ChatLoadingState(chatPartnerId: state.chatPartnerId));
      if (currentChat == null) {
        PeerPALUser chatPartner =
            await appUserRepository.getUser(state.chatPartnerId);
        PeerPALUser currentUser = await getAuthenticatedUser();
        emit(NewChatState(
            chatPartnerId: state.chatPartnerId,
            chatPartner: chatPartner,
            currentUser: currentUser));
        _startChatListener();
      } else {}
    }
  }

  StreamSubscription? _chatMessagesSubscription;
  StreamSubscription? _chatSubscription;

  _startChatListener() {
    _chatSubscription?.cancel();
    _chatSubscription = getAllUserChats().listen(
      (chats) async {
        UserChat? currentChat = chats
            .firstWhereOrNull((chat) => chat.user.id == state.chatPartnerId);
        if (currentChat != null) {
          PeerPALUser currentUser = await getAuthenticatedUser();
          PeerPALUser chatPartner =
              await appUserRepository.getUser(state.chatPartnerId);

          ChatLoadedState chatLoadedState = ChatLoadedState(
              messages: [],
              chatPartner: chatPartner,
              currentChat: currentChat,
              chatPartnerId: state.chatPartnerId,
              currentUser: currentUser);
          _startChatMessageListener(currentChat.chat.chatId, chatLoadedState);
        }
      },
      onError: (error) {
// ToDo: Implement.
      },
    );
  }

  _startChatMessageListener(String chatId, ChatLoadedState state) {
    _chatMessagesSubscription?.cancel();
    _chatMessagesSubscription =
        chatRepository.getChatMessagesForChat(chatId).listen(
      (messages) {
        emit(ChatLoadedState(
            messages: messages,
            chatPartner: state.chatPartner,
            currentChat: state.currentChat,
            currentUser: state.currentUser,
            chatPartnerId: state.chatPartnerId));
      },
      onError: (error) {
        // ToDo: Implement.
      },
    );
  }

  @override
  Future<void> close() {
    return super.close();
  }

  void sendMessage(
      {required PeerPALUser chatPartner,
      String? chatId,
      required String payload,
      required MessageType type}) {
    chatRepository.sendChatMessage(chatPartner, chatId, payload, type);
  }
}
