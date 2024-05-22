import 'package:flutter/material.dart';
import 'package:peerpal/app/data/resources/colors.dart';
import 'package:peerpal/chatv2/domain/core-usecases/cancel_friend_request.dart';
import 'package:peerpal/chatv2/domain/core-usecases/get_friend_list.dart';
import 'package:peerpal/chatv2/domain/core-usecases/get_sent_friend_requests.dart';
import 'package:peerpal/chatv2/domain/core-usecases/send_friend_request.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class FriendRequestButton extends StatelessWidget {
  final PeerPALUser chatPartner;
  final GetFriendList getFriendList;
  final CancelFriendRequest cancelFriendRequest;
  final GetSentFriendRequests getSentFriendRequests;
  final SendFriendRequest sendFriendRequest;

  const FriendRequestButton(
      {Key? key,
      required this.chatPartner,
      required this.getFriendList,
      required this.cancelFriendRequest,
      required this.getSentFriendRequests,
      required this.sendFriendRequest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PeerPALUser>>(
        stream: getFriendList(),
        builder:
            (context, AsyncSnapshot<List<PeerPALUser>> friendListSnapshot) {
          if (_isChatPartnerAFriend(friendListSnapshot)) {
            return Container();
          } else {
            return _buildFriendRequestButton();
          }
        });
  }

  bool _isChatPartnerAFriend(AsyncSnapshot<List<PeerPALUser>> snapshot) {
    if (!snapshot.hasData) return false;
    return snapshot.data!.any((user) => user.id == chatPartner.id);
  }

  Widget _buildFriendRequestButton() {
    return StreamBuilder<List<PeerPALUser>>(
      stream: getSentFriendRequests(),
      builder: (context,
          AsyncSnapshot<List<PeerPALUser>> sentFriendRequestsSnapshot) {
        if (!sentFriendRequestsSnapshot.hasData) return Container();

        if (_isFriendRequestPending(sentFriendRequestsSnapshot)) {
          return CancelFriendRequestButton(
            buttonText: "Anfrage gesendet",
            onPressed: () {
              cancelFriendRequest(chatPartner.id!);
            },
          );
        } else {
          return SendFriendRequestButton(
            buttonText: "Anfrage senden",
            onPressed: () {
              sendFriendRequest(chatPartner.id!);
            },
          );
        }
      },
    );
  }

  bool _isFriendRequestPending(AsyncSnapshot<List<PeerPALUser>> snapshot) {
    if (!snapshot.hasData) return false;
    return snapshot.data!.any((user) => user.id == chatPartner.id);
  }
}

class CancelFriendRequestButton extends StatelessWidget {
  CancelFriendRequestButton(
      {required this.buttonText, required this.onPressed});

  String buttonText;
  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom:
                  BorderSide(width: 1, color: PeerPALAppColor.secondaryColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 25, 0),
                child: Icon(
                  Icons.person_add,
                  color: PeerPALAppColor.primaryColor,
                  size: 25,
                ),
              ),
              CustomPeerPALHeading3(
                text: buttonText,
                color: PeerPALAppColor.primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                  minimumSize: const Size(50, 20),
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(0)),
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Abbrechen',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SendFriendRequestButton extends StatelessWidget {
  SendFriendRequestButton({required this.buttonText, required this.onPressed});

  String buttonText;
  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    width: 1, color: PeerPALAppColor.secondaryColor))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 25, 0),
                  child: Icon(
                    Icons.person_add,
                    color: PeerPALAppColor.primaryColor,
                    size: 25,
                  ),
                ),
                CustomPeerPALHeading3(
                  text: buttonText,
                  color: PeerPALAppColor.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
