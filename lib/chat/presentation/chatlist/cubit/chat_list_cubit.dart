import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/usecases/get_chats.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final GetChats _getChats;
  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<List<Chat>>? _chatSubscription;

  ChatListCubit(this._getChats, this._authenticationRepository)
      : super(ChatListState());

  void loadChatList() {
    String userId = _authenticationRepository.currentUser.id;
    _chatSubscription = _getChats(userId).listen((chats) {
      final filteredChats = chats.where((chat) {
        return chat.startedBy == userId || chat.chatRequestAccepted;
      }).toList();

      emit(state.copyWith(chats: filteredChats, status: ChatListStatus.success));
    });
  }

  @override
  Future<void> close() {
    _chatSubscription?.cancel();
    return super.close();
  }
}
