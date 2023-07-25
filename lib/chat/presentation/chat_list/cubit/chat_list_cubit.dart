import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/domain/usecases/get_all_userchats.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final GetAllUserChats _getAllUserChats;
  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<List<UserChat>>? _chatSubscription;

  ChatListCubit(this._getAllUserChats, this._authenticationRepository)
      : super(ChatListState());

  void loadChatList() {
    String userId = _authenticationRepository.currentUser.id;
    _chatSubscription = _getAllUserChats().listen((userChats) {
      final filteredUserChats = userChats.where((userChat) {
        return userChat.chat.startedBy == userId ||
            userChat.chat.chatRequestAccepted;
      }).toList();

      emit(state.copyWith(
          chats: filteredUserChats, status: ChatListStatus.success));
    });
  }

  @override
  Future<void> close() {
    _chatSubscription?.cancel();
    return super.close();
  }
}
