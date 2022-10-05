import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

class ChatHeaderBar extends StatelessWidget {
  final PeerPALUser chatPartner;

  final VoidCallback? onPressed;

  const ChatHeaderBar({
    required this.chatPartner,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
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
                Container(
                  width: 30,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                ClipOval(
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 22,
                      child: (chatPartner.imagePath == null ||
                              chatPartner.imagePath!.isEmpty)
                          ? Icon(
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
                            )),
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
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CustomPeerPalFontFamily',
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
        ));
  }
}
