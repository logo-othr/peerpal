import 'package:flutter/material.dart';
import 'package:peerpal/app/data/resources/colors.dart';

class ChatMessageInputField extends StatefulWidget {
  final TextEditingController textEditingController;
  final FocusNode focus;
  final VoidCallback sendTextMessage;
  final VoidCallback? sendImageMessage;

  const ChatMessageInputField(
      {required this.textEditingController,
      required this.focus,
      required this.sendTextMessage,
      this.sendImageMessage,
      Key? key})
      : super(key: key);

  @override
  State<ChatMessageInputField> createState() => _ChatMessageInputFieldState();
}

class _ChatMessageInputFieldState extends State<ChatMessageInputField> {
  @override
  Widget build(BuildContext context) {
    BoxDecoration messageInputContainerDecoration = BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: PeerPALAppColor.secondaryColor,
            width: 1.0,
          ),
        ));

    return Container(
      decoration: messageInputContainerDecoration,
      padding: const EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              style: TextStyle(fontSize: 22),
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              focusNode: widget.focus,
              onSubmitted: (value) {
                widget.sendTextMessage();
              },
              controller: widget.textEditingController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 20, top: 30, right: 20),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: PeerPALAppColor.primaryColor, width: 3.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: PeerPALAppColor.primaryColor, width: 3.0),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                hintText: 'Nachricht',
              ),
            ),
          ),
          const SizedBox(width: 10),
          widget.sendImageMessage != null
              ? Material(
                  color: Colors.white,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: IconButton(
                      icon: const Icon(Icons.add_photo_alternate, size: 35),
                      onPressed: () => widget.sendImageMessage!(),
                      color: PeerPALAppColor.primaryColor,
                    ),
                  ),
                )
              : Container(),
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: const Icon(Icons.send, size: 35),
                onPressed: () => widget.sendTextMessage(),
                color: PeerPALAppColor.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
