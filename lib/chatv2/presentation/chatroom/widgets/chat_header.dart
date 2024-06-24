import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chatv2/presentation/chatroom/widgets/friend_request_button/friend_request_cubit.dart';
import 'package:peerpal/chatv2/presentation/chatroom/widgets/friend_request_button/smart_friend_request_button.dart';
import 'package:peerpal/discover_feed_v2/domain/peerpal_user.dart';
import 'package:peerpal/setup.dart';

class ChatHeader extends StatelessWidget {
  final PeerPALUser chatPartner;
  final VoidCallback? onBackButtonPressed;
  final VoidCallback onBarPressed;

  const ChatHeader({
    required this.chatPartner,
    required this.onBackButtonPressed,
    required this.onBarPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ChatHeaderBar(
          chatPartner: chatPartner,
          onBackButtonPressed: onBackButtonPressed,
          onBarPressed: onBarPressed,
        ),
        BlocProvider(
          create: (context) => sl<FriendRequestCubit>()
            ..loadFriendRequestButton(chatPartner.id!),
          child: SmartFriendRequestButton(),
        )
      ],
    );
  }
}

class _ChatHeaderBar extends StatelessWidget {
  final PeerPALUser chatPartner;
  final VoidCallback? onBackButtonPressed;
  final VoidCallback? onBarPressed;

  const _ChatHeaderBar({
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
