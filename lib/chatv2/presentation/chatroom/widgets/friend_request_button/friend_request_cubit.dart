import 'dart:async';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:peerpal/chatv2/domain/core-usecases/cancel_friend_request.dart';
import 'package:peerpal/chatv2/domain/core-usecases/get_friend_list.dart';
import 'package:peerpal/chatv2/domain/core-usecases/get_sent_friend_requests.dart';
import 'package:peerpal/chatv2/domain/core-usecases/send_friend_request.dart';
import 'package:peerpal/discover_feed_v2/domain/peerpal_user.dart';

part 'friend_request_button_state.dart';

class FriendRequestCubit extends Cubit<FriendRequestState> {
  final GetFriendList _getFriendList;
  final CancelFriendRequest _cancelFriendRequest;
  final GetSentFriendRequests _getSentFriendRequests;
  final SendFriendRequest _sendFriendRequest;
  late final StreamSubscription<List<PeerPALUser>> _friendListSubscription;
  late final StreamSubscription<List<PeerPALUser>>
      _sentFriendRequestsSubscription;
  late final String chatPartnerId;

  FriendRequestCubit({
    required GetFriendList getFriendList,
    required CancelFriendRequest cancelFriendRequest,
    required GetSentFriendRequests getSentFriendRequests,
    required SendFriendRequest sendFriendRequest,
  })  : _sendFriendRequest = sendFriendRequest,
        _getSentFriendRequests = getSentFriendRequests,
        _cancelFriendRequest = cancelFriendRequest,
        _getFriendList = getFriendList,
        super(FriendRequestInitial());

  Future<void> loadFriendRequestButton(String chatPartnerId) async {
    this.chatPartnerId = chatPartnerId;
    _friendListSubscription = _getFriendList().listen((friendList) {
      if (_isChatPartnerAFriend(friendList)) {
        emit(FriendRequestHidden());
      }
    });

    _sentFriendRequestsSubscription =
        _getSentFriendRequests().listen((sentRequests) {
      if (_isFriendRequestPending(sentRequests)) {
        emit(FriendRequestPending());
      } else {
        emit(FriendRequestVisible());
      }
    });
  }

  bool _isChatPartnerAFriend(friendList) {
    return friendList.any((user) => user.id == chatPartnerId);
  }

  bool _isFriendRequestPending(friendList) {
    return friendList.any((user) => user.id == chatPartnerId);
  }

  void sendFriendRequest() {
    _sendFriendRequest(chatPartnerId);
  }

  void cancelFriendRequest() {
    _cancelFriendRequest(chatPartnerId);
  }

  @override
  Future<void> close() {
    _friendListSubscription.cancel();
    _sentFriendRequestsSubscription.cancel();
    return super.close();
  }
}
