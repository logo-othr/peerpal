import 'package:flutter/material.dart';
import 'package:peerpal/repository/emojis.dart';
import 'package:peerpal/widgets/emoji_button.dart';

class ChatEmojiKeyboard extends StatefulWidget {
  VoidCallback onCancel;
  final TextEditingController textEditingController;

  //VoidCallback onPressedEmojiKeyboardItem;

  ChatEmojiKeyboard({required this.onCancel, required this.textEditingController
      /*required this.onPressedEmojiKeyboardItem*/
      });

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
      initialIndex: 1,
      length: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          customEmojiHeaderBar(widget.onCancel),
          SizedBox(
            height: 100,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
              child: TabBarView(
                children: [
                  Wrap(
                    children: activityEmojiButtons,
                  ),
                  Wrap(
                    children: eatAndDrinkEmojis,
                  ),
                  Wrap(
                    children: year,
                  ),
                  Wrap(
                    children: gestures,
                  ),
                  Wrap(
                    children: smileyAndEmotionsEmojis,
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
      padding: const EdgeInsets.fromLTRB(0, 10, 15, 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: SizedBox(
              height: 40,
              width: 170,
              child: TabBar(
                  labelPadding: EdgeInsets.all(0),
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 1.0, color: Colors.white)),
                  tabs: [
                    EmojiButton(
                        emojiCode: Emojis.activityEmojis.first.code),
                    EmojiButton(emojiCode: Emojis.eatAndDrinkEmojis.first.code),
                    EmojiButton(emojiCode: Emojis.year.first.code),
                    EmojiButton(emojiCode: Emojis.gestures.first.code),
                    EmojiButton(
                        emojiCode: Emojis.smileyAndEmotionsEmojis.first.code),
                  ]),
            ),
          ),
          GestureDetector(
              onTap: () {
                onCancel();
              },
              child: const Text(
                'Abbrechen',
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
        ],
      ),
    );
  }
}
