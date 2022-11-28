import 'package:cached_network_image/cached_network_image.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/chat/domain/message_type.dart';
import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/chat/presentation/chat/bloc/chat_page_bloc.dart';
import 'package:peerpal/data/resources/colors.dart';
import 'package:peerpal/widgets/custom_loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageList extends StatefulWidget {
  final ChatLoadedState state;

  const MessageList({Key? key, required this.state}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState(state: state);
}

class _MessageListState extends State<MessageList> {
  final ChatLoadedState state;
  final ScrollController _listScrollController = ScrollController();
  String phoneNumberPattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';

  _MessageListState({required this.state});

  _scrollListener() {
    if (_listScrollController.hasClients) {
      if (_listScrollController.offset >=
              _listScrollController.position.maxScrollExtent &&
          !_listScrollController.position.outOfRange) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    _listScrollController.addListener(_scrollListener);

    return Flexible(
        child: StreamBuilder<List<ChatMessage>>(
      stream: widget.state.messages,
      builder:
          (BuildContext context, AsyncSnapshot<List<ChatMessage>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return Container(
                height: 100,
                alignment: Alignment.center,
                child: Text("Keine Nachrichten gefunden"));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemBuilder: (context, index) {
              ChatMessage message = snapshot.data![index];
              var isAppUserMessage =
                  (message.userId == widget.state.appUser.id);
              var imageUrl = isAppUserMessage
                  ? widget.state.appUser.imagePath
                  : widget.state.chatPartner.imagePath;
              return buildChatMessage(message, isAppUserMessage, imageUrl!);
            },
            itemCount: snapshot.data?.length,
            reverse: true,
            controller: _listScrollController,
          );
        } else {
          return Center(
            child: CustomLoadingIndicator(text: "Lade Daten..."),
          );
        }
      },
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
            ? TextButton(
                onPressed: () async {
                  //FlutterPhoneDirectCaller.callNumber(chatMessage.message);
                  Uri phoneno = Uri.parse('tel:${chatMessage.message}');
                  await launchUrl(phoneno);
                },
                child: new SelectableText(
                  chatMessage.message,
                  style: const TextStyle(color: Colors.black, fontSize: 19),
                  textAlign: TextAlign.start,
                ))
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
