import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:peerpal/chat/domain/models/user_chat.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

part 'chat_input_panel_state.dart';

class ChatInputPanelCubit extends Cubit<ChatInputPanelState> {
  final ChatRepository chatRepository;
  final String currentUserId;
  final UserChat userChat;
  final PeerPALUser appUser;
  final PeerPALUser chatPartner;
  StreamSubscription? messageCountSubscription;

  ChatInputPanelCubit({
    required this.chatRepository,
    required this.currentUserId,
    required this.userChat,
    required this.appUser,
    required this.chatPartner,
  }) : super(ChatInputPanelInitialState()) {
  }

  void loadChat() {
    final bool isStartedByMe = userChat.chat.startedBy == appUser.id;
    final bool isRequestAccepted = userChat.chat.chatRequestAccepted;

    messageCountSubscription = chatRepository
        .messageCountForChat(userChat.chat.chatId)
        .listen(
          (messageCount) => emit(ChatInputPanelLoadedState(
            messageCount: messageCount,
            isChatNotStartedByAppUser: !isStartedByMe,
            isChatRequestNotAccepted: !isRequestAccepted,
          )),
          onError: (error) =>
              emit(ChatInputPanelErrorState(errorMessage: error.toString())),
        );
  }

  Future<void> sendChatRequestResponse(bool response) async {
    try {
      await chatRepository.sendChatRequestResponse(
        chatPartner.id!,
        response,
        userChat.chat.chatId,
      );
    } catch (e) {
      emit(ChatInputPanelErrorState(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    messageCountSubscription?.cancel();
    return super.close();
  }
}
