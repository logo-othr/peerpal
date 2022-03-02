import 'package:flutter/material.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/widgets/chat_answer_button.dart';
import 'package:peerpal/widgets/chat_emoji_button.dart';

class ChatButtons extends StatefulWidget {

  final TextEditingController textEditingController;

  ChatButtons({required this.textEditingController});

  @override
  State<ChatButtons> createState() => _ChatButtonsState();
}

class _ChatButtonsState extends State<ChatButtons> {
  bool toggleChatAnswerKeyboard = false;
  bool toggleChatEmojiKeyboard = false;

  void onCancelAnswerKeyboard() {
    /*  Future.delayed(
        const Duration(milliseconds: 800),
    );*/
    setState(() {
      toggleChatAnswerKeyboard = false;
    });
  }

  void onCancelEmojiKeyboard() {
    /*  Future.delayed(
        const Duration(milliseconds: 800));*/
    setState(() {
      toggleChatEmojiKeyboard = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(25);
    const borderRadius = BorderRadius.all(radius);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        toggleChatAnswerKeyboard
            ? Container()
            : AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                height: toggleChatEmojiKeyboard ? 200 : 35,
                width: toggleChatEmojiKeyboard ? 280 : 35,
                duration: const Duration(milliseconds: 0),
                margin: toggleChatEmojiKeyboard
                    ? const EdgeInsets.fromLTRB(0, 5, 10, 5)
                    : const EdgeInsets.fromLTRB(0, 5, 5, 5),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: toggleChatEmojiKeyboard ?  borderRadius
                      .subtract(const BorderRadius.only(bottomRight: radius)) :BorderRadius.circular(25),
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      toggleChatEmojiKeyboard = true;
                    });
                  },
                  child: toggleChatEmojiKeyboard
                      ? ChatEmojiKeyboard(
                          onCancel:
                              onCancelEmojiKeyboard, textEditingController: widget.textEditingController, /*onPressedEmojiKeyboardItem:*/
                        )
                      : const Icon(
                          Icons.emoji_emotions_outlined,
                          size: 25,
                          color: Colors.white,
                        ),
                )),
        toggleChatEmojiKeyboard
            ? Container()
            : AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                height: toggleChatAnswerKeyboard ? 250 : 35,
                width: toggleChatAnswerKeyboard ? 300 : 120,
                duration: const Duration(milliseconds: 0),
                margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: borderRadius
                      .subtract(const BorderRadius.only(bottomRight: radius)),
                ),
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        toggleChatAnswerKeyboard = true;
                      });
                    },
                    child: toggleChatAnswerKeyboard
                        ? ChatAnswerKeyboard(
                            onCancel:
                                onCancelAnswerKeyboard, textEditingController: widget.textEditingController, /*onPressedAnswerKeyboardItem:*/
                          )
                        : const Center(
                            child: Text(
                            'Antwort wählen',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )))),
      ],
    );
  }
}
