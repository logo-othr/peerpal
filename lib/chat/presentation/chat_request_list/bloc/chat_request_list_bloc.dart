import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/domain/usecases/get_chat_requests_for_user.dart';
import 'package:peerpal/chat/domain/usecases/get_chats_for_users.dart';
import 'package:rxdart/rxdart.dart';

part 'chat_request_list_event.dart';
part 'chat_request_list_state.dart';

class ChatRequestListBloc
    extends Bloc<ChatRequestListEvent, ChatRequestListState> {
  final GetChatsForUser _getChatsForUser;
  final GetChatRequestForUser _getChatRequestForUser;
  final StreamController<List<Chat>> _chatStreamController =
      BehaviorSubject<List<Chat>>();
  final StreamController<List<UserChat>> _userFriendRequestStreamController =
      BehaviorSubject<List<UserChat>>();
  late StreamSubscription _chatSubscription;
  late StreamSubscription _chatRequestSubscription;

  ChatRequestListBloc(this._getChatsForUser, this._getChatRequestForUser)
      : super(ChatRequestListState());

  @override
  Future<void> close() {
    _chatSubscription.cancel();
    _chatRequestSubscription.cancel();
    _chatStreamController.close();
    _userFriendRequestStreamController.close();
    return super.close();
  }

  @override
  Stream<ChatRequestListState> mapEventToState(
      ChatRequestListEvent event) async* {
    if (event is ChatRequestListLoaded) {
      _chatSubscription = _getChatsForUser().listen((chatList) {
        _chatStreamController.add(chatList);
      });

      _chatRequestSubscription =
          _getChatRequestForUser(_chatStreamController.stream)
              .listen((userChatList) {
        _userFriendRequestStreamController.add(userChatList);
      });

      yield* _mapChatRequestsToState();
    }
  }

  Stream<ChatRequestListState> _mapChatRequestsToState() async* {
    yield ChatRequestListState(
      status: ChatRequestListStatus.success,
      chatRequests: _userFriendRequestStreamController.stream,
    );
  }
}

class ChatRequestListSuccess extends ChatRequestListEvent {
  final List<UserChat> userChatList;

  ChatRequestListSuccess(this.userChatList);

  @override
  List<Object> get props => [userChatList];
}
