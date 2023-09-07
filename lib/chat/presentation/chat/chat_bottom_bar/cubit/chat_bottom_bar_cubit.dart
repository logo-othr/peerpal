import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:peerpal/chat/domain/models/user_chat.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

part 'chat_bottom_bar_state.dart';

class ChatBottomBarCubit extends Cubit<ChatBottomBarState> {
  final ChatRepository chatRepository;
  final String currentUserId;
  final UserChat userChat;
  final PeerPALUser appUser;
  final PeerPALUser chatPartner;
  StreamSubscription? messageCountSubscription;

  ChatBottomBarCubit({
    required this.chatRepository,
    required this.currentUserId,
    required this.userChat,
    required this.appUser,
    required this.chatPartner,
  }) : super(ChatBottomBarInitialState()) {
    loadChat();
  }

  void loadChat() {
    final bool isChatNotStartedByAppUser =
        userChat.chat.startedBy != appUser.id;
    final bool isChatRequestNotAccepted = !userChat.chat.chatRequestAccepted;

    messageCountSubscription =
        chatRepository.messageCountForChat(userChat.chat.chatId).listen(
              (messageCount) => emit(ChatBottomBarLoadedState(
                messageCount: messageCount,
                isChatNotStartedByAppUser: isChatNotStartedByAppUser,
                isChatRequestNotAccepted: isChatRequestNotAccepted,
              )),
              onError: (error) =>
                  emit(ChatBottomBarErrorState(errorMessage: error.toString())),
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
      emit(ChatBottomBarErrorState(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    messageCountSubscription?.cancel();
    return super.close();
  }
}
