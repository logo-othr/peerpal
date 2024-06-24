import 'package:cached_network_image/cached_network_image.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/app/data/resources/colors.dart';
import 'package:peerpal/chatv2/domain/enums/message_type.dart';
import 'package:peerpal/chatv2/domain/models/chat_message.dart';
import 'package:peerpal/discover_feed_v2/domain/peerpal_user.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageList extends StatelessWidget {
  final PeerPALUser appUser;
  final List<ChatMessage> messages;
  final ScrollController _listScrollController = ScrollController();

// TODO: Refactor to separate business logic from the presentation layer
  final String phoneNumberPattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';

  MessageList({Key? key, required this.appUser, required this.messages})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (context, index) {
        ChatMessage message = messages[index];
        var isAppUserMessage = (message.userId == appUser.id);
        var imageUrl = isAppUserMessage ? appUser.imagePath : appUser.imagePath;
        return buildChatMessage(message, isAppUserMessage, imageUrl!);
      },
      itemCount: messages.length,
      reverse: true,
      controller: _listScrollController,
    ));
  }

  Widget buildChatMessage(
      ChatMessage chatMessage, bool isRightAligned, String imageUrl) {
    const radius = Radius.circular(12);
    const borderRadius = BorderRadius.all(radius);
    return Row(
      mainAxisAlignment:
          isRightAligned ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          decoration: BoxDecoration(
            color: isRightAligned
                ? PeerPALAppColor.primaryColor.shade400
                : PeerPALAppColor.secondaryColor.shade400,
            borderRadius: isRightAligned
                ? borderRadius
                    .subtract(const BorderRadius.only(topRight: radius))
                : borderRadius
                    .subtract(const BorderRadius.only(topLeft: radius)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _message(chatMessage),
              const SizedBox(width: 15),
              ClipOval(
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: (imageUrl.isEmpty)
                          ? Icon(
                              Icons.account_circle,
                              size: 40.0,
                              color: Colors.grey,
                            )
                          : CachedNetworkImage(
                              imageUrl: imageUrl,
                              errorWidget: (context, object, stackTrace) {
                                return const Icon(
                                  Icons.account_circle,
                                  size: 40.0,
                                  color: Colors.grey,
                                );
                              },
                            ))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _message(ChatMessage chatMessage) {
    RegExp regExp = new RegExp(phoneNumberPattern);

    if (EnumToString.fromString(MessageType.values, chatMessage.type) ==
        MessageType.text) {
      return Container(
        constraints: const BoxConstraints(maxWidth: 220),
        child: regExp.hasMatch(chatMessage.message)
            ? Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () async {
                          //FlutterPhoneDirectCaller.callNumber(chatMessage.message);
                          Uri phoneno = Uri.parse('tel:${chatMessage.message}');
                          await launchUrl(phoneno);
                        },
                        icon: Icon(Icons.phone)),
                    new SelectableText(
                      chatMessage.message,
                      style: const TextStyle(color: Colors.black, fontSize: 19),
                      textAlign: TextAlign.start,
                    )
                  ],
                ),
              )
            : SelectableText(
                chatMessage.message,
                style: const TextStyle(color: Colors.black, fontSize: 19),
                textAlign: TextAlign.start,
              ),
      );
    } else if (EnumToString.fromString(MessageType.values, chatMessage.type) ==
        MessageType.image) {
      return Container(
        constraints: const BoxConstraints(maxWidth: 220, maxHeight: 300),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitHeight,
            image: CachedNetworkImageProvider(chatMessage.message),
          ),
          shape: BoxShape.rectangle,
        ),
      );
    } else {
      return Text("Fehler beim laden der Nachricht.");
    }
  }
}
