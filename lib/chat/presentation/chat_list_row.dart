import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peerpal/app/data/resources/colors.dart';
import 'package:peerpal/chat/domain/message_type.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class ChatListRow extends StatelessWidget {
  final VoidCallback onPressed;
  final UserChat userChat;
  final bool newMessageIndicator;

  ChatListRow({
    required this.onPressed,
    required this.userChat,
    required this.newMessageIndicator,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 16,
      fontFamily: 'Roboto',
      color: Colors.black,
    );

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom:
                  BorderSide(width: 1, color: PeerPALAppColor.secondaryColor))),
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          children: [
            _UserAvatar(chatData: userChat),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _UserNameText(chatData: userChat),
                  SizedBox(height: 5),
                  _LastMessage(chatData: userChat, textStyle: textStyle),
                  newMessageIndicator
                      ? _NewMessageIndicator()
                      : SizedBox.shrink(),
                  Text(getFormattedDate(userChat)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getFormattedDate(UserChat chatData) {
    return DateFormat('dd.MM.yyyy - kk:mm').format(
        DateTime.fromMillisecondsSinceEpoch(
            int.parse(chatData.chat.lastUpdated)));
  }
}

class _UserAvatar extends StatelessWidget {
  final UserChat chatData;

  const _UserAvatar({
    Key? key,
    required this.chatData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (chatData.user.imagePath == null || chatData.user.imagePath!.isEmpty) {
      return DefaultUserAvatar();
    }

    return _NetworkUserAvatar(imagePath: chatData.user.imagePath!);
  }
}

class DefaultUserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Icon(
        Icons.account_circle,
        size: 60.0,
        color: Colors.grey,
      ),
    );
  }
}

class _NetworkUserAvatar extends StatelessWidget {
  final String imagePath;

  const _NetworkUserAvatar({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      errorWidget: (context, object, stackTrace) => DefaultUserAvatar(),
      imageUrl: imagePath,
      fit: BoxFit.cover,
      width: 60.0,
      height: 60.0,
    );
  }
}

class _UserNameText extends StatelessWidget {
  final UserChat chatData;

  const _UserNameText({Key? key, required this.chatData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPeerPALHeading3(
      text: chatData.user.name!,
      color: PeerPALAppColor.primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
  }
}

class _LastMessage extends StatelessWidget {
  final UserChat chatData;
  final TextStyle textStyle;

  const _LastMessage({
    Key? key,
    required this.chatData,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            _getLastMessage(chatData),
            style: textStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _getLastMessage(UserChat chatData) {
    if (chatData.chat.lastMessage == null) {
      return "Nachricht konnte nicht geladen werden";
    }

    if (chatData.chat.lastMessage!.type == MessageType.image) {
      return "Foto";
    }

    return chatData.chat.lastMessage!.message.toString();
  }
}

class _NewMessageIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 40, 0),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        child: Padding(
          padding: const EdgeInsets.all(7.0),
        ),
      ),
    );
  }
}
