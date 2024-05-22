import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/chatv2/domain/core-usecases/cancel_friend_request.dart';
import 'package:peerpal/chatv2/domain/core-usecases/get_friend_list.dart';
import 'package:peerpal/chatv2/domain/core-usecases/get_sent_friend_requests.dart';
import 'package:peerpal/chatv2/domain/core-usecases/send_friend_request.dart';
import 'package:peerpal/chatv2/presentation/widgets/friend_request_button.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

class ChatHeader extends StatelessWidget {
  final PeerPALUser chatPartner;
  final VoidCallback? onBackButtonPressed;
  final VoidCallback onBarPressed;
  final GetFriendList getFriendList;
  final CancelFriendRequest cancelFriendRequest;
  final GetSentFriendRequests getSentFriendRequests;
  final SendFriendRequest sendFriendRequest;

  const ChatHeader({
    required this.chatPartner,
    required this.onBackButtonPressed,
    required this.onBarPressed,
    required this.getFriendList,
    required this.cancelFriendRequest,
    required this.getSentFriendRequests,
    required this.sendFriendRequest,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChatHeaderBar(
          chatPartner: chatPartner,
          onBackButtonPressed: onBackButtonPressed,
          onBarPressed: onBarPressed,
        ),
        FriendRequestButton(
          chatPartner: chatPartner,
          getFriendList: getFriendList,
          cancelFriendRequest: cancelFriendRequest,
          getSentFriendRequests: getSentFriendRequests,
          sendFriendRequest: sendFriendRequest,
        )
      ],
    );
  }
}

class ChatHeaderBar extends StatelessWidget {
  final PeerPALUser chatPartner;
  final VoidCallback? onBackButtonPressed;
  final VoidCallback? onBarPressed;

  const ChatHeaderBar({
    required this.chatPartner,
    required this.onBackButtonPressed,
    required this.onBarPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBarPressed,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        height: 68,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: onBackButtonPressed ??
                    () {
                      Navigator.of(context).pop();
                    },
              ),
              ClipOval(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 22,
                  child: (chatPartner.imagePath == null ||
                          chatPartner.imagePath!.isEmpty)
                      ? const Icon(
                          Icons.account_circle,
                          size: 40.0,
                          color: Colors.grey,
                        )
                      : CachedNetworkImage(
                          imageUrl: chatPartner.imagePath!,
                          errorWidget: (context, object, stackTrace) {
                            return const Icon(
                              Icons.account_circle,
                              size: 40.0,
                              color: Colors.grey,
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(width: 15),
              Flexible(
                child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: chatPartner.name!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
