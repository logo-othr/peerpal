import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/models/user_chat.dart';
import 'package:peerpal/chat/domain/usecases/get_all_userchats.dart';

part 'chat_requests_state.dart';

class ChatRequestsCubit extends Cubit<ChatRequestsState> {
  final GetAllUserChats _getAllUserChats;
  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<List<UserChat>>? _requestsSubscription;

  ChatRequestsCubit(this._getAllUserChats, this._authenticationRepository)
      : super(ChatRequestsState());

  void loadChatRequests() async {
    final userChatsStream = _getAllUserChats();
    String userId = _authenticationRepository.currentUser.id;
    _requestsSubscription = userChatsStream.listen((userChats) {
      final filteredUserChats = userChats.where((userChat) {
        return userChat.chat.startedBy != userId &&
            !userChat.chat.chatRequestAccepted;
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
