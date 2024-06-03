import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chatv2/domain/models/chat.dart';
import 'package:peerpal/chatv2/domain/usecases/get_chats.dart';

part 'chat_requests_state.dart';

class ChatRequestsCubit extends Cubit<ChatRequestsState> {
  final GetChats _getChats;
  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<List<Chat>>? _requestsSubscription;

  ChatRequestsCubit(this._getChats, this._authenticationRepository)
      : super(ChatRequestsState());

  void loadChatRequests() async {
    String userId = _authenticationRepository.currentUser.id;
    final userChatsStream = _getChats(userId);

    _requestsSubscription = userChatsStream.listen((chats) {
      final filteredUserChats = chats.where((chat) {
        return chat.startedBy != userId && chat.chatRequestAccepted;
      }).toList();

      emit(state.copyWith(
          status: ChatRequestsStatus.success, requests: filteredUserChats));
    });
  }

  @override
  Future<void> close() {
    _requestsSubscription?.cancel();
    return super.close();
  }
}
