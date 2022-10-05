import 'package:flutter/material.dart';
import 'package:peerpal/discover/data/repository/app_user_repository.dart';
import 'package:peerpal/discover/domain/peerpal_user.dart';
import 'package:peerpal/widgets/single_chat_cancel_friend_request_button.dart';
import 'package:peerpal/widgets/single_chat_send_friend_request_button.dart';

class FriendRequestButton extends StatelessWidget {
  final PeerPALUser chatPartner;
  final AppUserRepository _appUserRepository;

  const FriendRequestButton(
      {Key? key,
      required this.chatPartner,
      required AppUserRepository appUserRepository})
      : this._appUserRepository = appUserRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PeerPALUser>>(
        stream: _appUserRepository.getFriendList(),
        builder:
            (context, AsyncSnapshot<List<PeerPALUser>> friendListSnapshot) {
          if (!friendListSnapshot.hasData ||
              _chatPartnerIsAFriend(friendListSnapshot, chatPartner)) {
            return Container();
          } else {
            return _friendRequestButton();
          }
        });
  }

  Widget _friendRequestButton() {
    return StreamBuilder<List<PeerPALUser>>(
        stream: _appUserRepository.getSentFriendRequestsFromUser(),
        builder: (context,
            AsyncSnapshot<List<PeerPALUser>> sentFriendRequestsSnapshot) {
          if (sentFriendRequestsSnapshot.hasData) {
            if (_friendRequestPending(
                sentFriendRequestsSnapshot, chatPartner)) {
              return _cancelFriendRequestButton();
            } else {
              return _sendFriendRequestButton();
            }
          } else {
            return Container();
          }
        });
  }

  bool _chatPartnerIsAFriend(
      AsyncSnapshot<List<PeerPALUser>> friendListSnapshot,
      PeerPALUser chatPartner) {
    return friendListSnapshot.data!
        .map((e) => e.id)
        .toList()
        .contains(chatPartner.id);
  }

  bool _friendRequestPending(
      AsyncSnapshot<List<PeerPALUser>> friendRequestsSnapshot,
      PeerPALUser chatPartner) {
    return friendRequestsSnapshot.data!
        .map((e) => e.id)
        .toList()
        .contains(chatPartner.id);
  }

  Widget _sendFriendRequestButton() {
    return SendFriendRequestButton(
        buttonText: "Anfrage senden",
        onPressed: () {
          _appUserRepository.sendFriendRequestToUser(chatPartner);
        });
  }

  Widget _cancelFriendRequestButton() {
    return CancelFriendRequestButton(
        buttonText: "Anfrage gesendet",
        onPressed: () {
          _appUserRepository.canceledFriendRequest(chatPartner);
        });
  }
}
