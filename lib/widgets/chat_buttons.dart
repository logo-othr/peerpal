import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
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

  late StreamSubscription<bool> keyboardSubscription;


  @override
  void initState() {
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print('Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: $visible');
  if(visible) {
    setState(() {
      isAnswerKeyboardVisible = false;
      isEmojiKeyboardVisible = false;
    });
  }
    });
  }

  bool isAnswerKeyboardVisible = false;
  bool isEmojiKeyboardVisible = false;

  void onCancelAnswerKeyboard() {
    /*  Future.delayed(
        const Duration(milliseconds: 800),
    );*/
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {
      isAnswerKeyboardVisible = false;
    });
  }

  void onCancelEmojiKeyboard() {
    /*  Future.delayed(
        const Duration(milliseconds: 800));*/
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {
      isEmojiKeyboardVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(25);
    const borderRadius = BorderRadius.all(radius);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        isAnswerKeyboardVisible
            ? Container()
            : AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                height: isEmojiKeyboardVisible ? 200 : 35,
                width: isEmojiKeyboardVisible ? 280 : 35,
                duration: const Duration(milliseconds: 0),
                margin: isEmojiKeyboardVisible
                    ? const EdgeInsets.fromLTRB(0, 5, 10, 5)
                    : const EdgeInsets.fromLTRB(0, 5, 5, 5),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: isEmojiKeyboardVisible ?  borderRadius
                      .subtract(const BorderRadius.only(bottomRight: radius)) :BorderRadius.circular(25),
                ),
                child: GestureDetector(
                  onTap: () {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    setState(() {
                      isEmojiKeyboardVisible = true;
                    });
                  },
                  child: isEmojiKeyboardVisible
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
        isEmojiKeyboardVisible
            ? Container()
            : AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                height: isAnswerKeyboardVisible ? 250 : 35,
                width: isAnswerKeyboardVisible ? 300 : 120,
                duration: const Duration(milliseconds: 0),
                margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: borderRadius
                      .subtract(const BorderRadius.only(bottomRight: radius)),
                ),
                child: GestureDetector(
                    onTap: () {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      setState(() {
                        isAnswerKeyboardVisible = true;
                      });
                    },
                    child: isAnswerKeyboardVisible
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
