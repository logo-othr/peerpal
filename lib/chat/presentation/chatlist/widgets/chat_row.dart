import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:peerpal/app/data/resources/colors.dart';
import 'package:peerpal/chat/domain/enums/message_type.dart';
import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/chat/presentation/chatroom/chatroom_page.dart';

import 'chat_row_cubit.dart';

class ChatListRow extends StatelessWidget {
  const ChatListRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRowCubit, ChatRowState>(
      builder: (context, state) {
        if (state.status == ChatRowStatus.success) {
          final textStyle = const TextStyle(
            fontSize: 16,
            fontFamily: 'Roboto',
            color: Colors.black,
          );

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom:
                    BorderSide(width: 1, color: PeerPALAppColor.secondaryColor),
              ),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatroomPage(
                      chatPartnerId: state.user.id,
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  _UserAvatar(imagePath: state.user.imagePath),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _UserNameText(userName: state.user.name),
                        const SizedBox(height: 5),
                        _LastMessage(
                            lastMessage: state.chat?.lastMessage,
                            textStyle: textStyle),
                        //  if (newMessageIndicator) const _NewMessageIndicator(),
                        Text(_getFormattedDate(state.chat!.lastUpdated)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  String _getFormattedDate(String lastUpdated) {
    return DateFormat('dd.MM.yyyy - kk:mm').format(
      DateTime.fromMillisecondsSinceEpoch(
        int.parse(lastUpdated),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String? imagePath;

  const _UserAvatar({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imagePath == null || imagePath!.isEmpty
        ? const _DefaultUserAvatar()
        : _NetworkUserAvatar(imagePath: imagePath!);
  }
}

class _DefaultUserAvatar extends StatelessWidget {
  const _DefaultUserAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imagePath,
          width: 60.0,
          height: 60.0,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => const _DefaultUserAvatar(),
        ),
      ),
    );
  }
}

class _UserNameText extends StatelessWidget {
  final String? userName;

  const _UserNameText({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      userName ?? "Unknown",
      style: TextStyle(
        color: PeerPALAppColor.primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }
}

class _LastMessage extends StatelessWidget {
  final ChatMessage? lastMessage;
  final TextStyle textStyle;

  const _LastMessage({
    Key? key,
    required this.lastMessage,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      _getLastMessage(),
      style: textStyle,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _getLastMessage() {
    if (lastMessage == null) {
      return "Nachricht konnte nicht geladen werden";
    }

    if (lastMessage!.type == MessageType.image) {
      return "Foto";
    }

    return lastMessage!.message.toString();
  }
}

class _NewMessageIndicator extends StatelessWidget {
  const _NewMessageIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 40, 0),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        child: const Padding(
          padding: EdgeInsets.all(7.0),
        ),
      ),
    );
  }
}
