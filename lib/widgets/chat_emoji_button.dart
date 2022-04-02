import 'package:flutter/material.dart';
import 'package:peerpal/repository/emojis.dart';
import 'package:peerpal/widgets/emoji_button.dart';

import '../colors.dart';

class ChatEmojiKeyboard extends StatefulWidget {
  VoidCallback onCancel;
  final TextEditingController textEditingController;

  ChatEmojiKeyboard(
      {required this.onCancel, required this.textEditingController});

  @override
  State<ChatEmojiKeyboard> createState() => _ChatEmojiKeyboardState();
}

class _ChatEmojiKeyboardState extends State<ChatEmojiKeyboard> {
  List<Widget> activityEmojiButtons = [];
  List<Widget> eatAndDrinkEmojis = [];
  List<Widget> year = [];
  List<Widget> gestures = [];
  List<Widget> smileyAndEmotionsEmojis = [];

  void addStringToTextController(
      TextEditingController controller, String string) {
    String currentText = controller.text.toString();
    String updatedText = "${currentText}${string}";
    controller.text = updatedText;
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
  }

  @override
  Widget build(BuildContext context) {
    activityEmojiButtons = Emojis.activityEmojis
        .map((emojiData) => EmojiButton(
        onPressed: () => addStringToTextController(
            widget.textEditingController, emojiData.code),
        emojiCode: emojiData.code))
        .toList();

    eatAndDrinkEmojis = Emojis.eatAndDrinkEmojis
        .map((emojiData) => EmojiButton(
        onPressed: () => addStringToTextController(
            widget.textEditingController, emojiData.code),
        emojiCode: emojiData.code))
        .toList();

    year = Emojis.year
        .map((emojiData) => EmojiButton(
        onPressed: () => addStringToTextController(
            widget.textEditingController, emojiData.code),
        emojiCode: emojiData.code))
        .toList();

    gestures = Emojis.gestures
        .map((emojiData) => EmojiButton(
        onPressed: () => addStringToTextController(
            widget.textEditingController, emojiData.code),
        emojiCode: emojiData.code))
        .toList();

    smileyAndEmotionsEmojis = Emojis.smileyAndEmotionsEmojis
        .map((emojiData) => EmojiButton(
        onPressed: () => addStringToTextController(
            widget.textEditingController, emojiData.code),
        emojiCode: emojiData.code))
        .toList();

    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          customEmojiHeaderBar(widget.onCancel),
          Divider(
            thickness: 2,
            color: primaryColor,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              //color: Colors.green,
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Wrap(
                      children: activityEmojiButtons,
                    ),
                  ),
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Wrap(
                      children: eatAndDrinkEmojis,
                    ),
                  ),
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Wrap(
                      children: year,
                    ),
                  ),
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Wrap(
                      children: gestures,
                    ),
                  ),
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Wrap(
                      children: smileyAndEmotionsEmojis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customEmojiHeaderBar(onCancel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      decoration: const BoxDecoration(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(25), topLeft: Radius.circular(25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 70,
            child: Container(
              height: 50,
              child: TabBar(
                  unselectedLabelColor: Colors.white,
                  labelPadding: EdgeInsets.all(0),
                  indicator: UnderlineTabIndicator(
                      borderSide:
                      BorderSide(width: 2.0, color: primaryColor)),
                  tabs: [
                    Text(Emojis.activityEmojis.first.code, style: TextStyle(fontSize: 28)),
                    Text(Emojis.eatAndDrinkEmojis.first.code, style: TextStyle(fontSize: 28)),
                    Text(Emojis.year.first.code, style: TextStyle(fontSize: 28)),
                    Text(Emojis.gestures.first.code, style: TextStyle(fontSize: 28)),
                    Text(Emojis.smileyAndEmotionsEmojis.first.code, style: TextStyle(fontSize: 28)),
                  ]),
            ),
          ),
          Flexible(
            flex: 30,
            child: GestureDetector(
                onTap: () {
                  onCancel();
                },
                child: Container(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Schließen',
                        style: TextStyle(color: primaryColor, fontSize: 18),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
