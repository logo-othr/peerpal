import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:peerpal/app/data/resources/colors.dart';
import 'package:peerpal/app_logger.dart';
import 'package:peerpal/widgets/chat_answer_button.dart';
import 'package:peerpal/widgets/chat_emoji_button.dart';

class ChatButtons extends StatefulWidget {
  final TextEditingController textEditingController;
  final String? appUserPhoneNumber;

  ChatButtons(this.appUserPhoneNumber, {required this.textEditingController});

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
    logger.i(
        'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      logger.i('Keyboard visibility update. Is visible: $visible');
      if (visible) {
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
                height: isEmojiKeyboardVisible ? 210 : 45,
                width: isEmojiKeyboardVisible ? 320 : 45,
                duration: const Duration(milliseconds: 0),
                margin: isEmojiKeyboardVisible
                    ? const EdgeInsets.fromLTRB(0, 5, 10, 5)
                    : const EdgeInsets.fromLTRB(0, 5, 5, 5),
                decoration: BoxDecoration(
                  color: isEmojiKeyboardVisible
                      ? Colors.white
                      : PeerPALAppColor.primaryColor,
                  border:
                      Border.all(width: 2, color: PeerPALAppColor.primaryColor),
                  borderRadius: isEmojiKeyboardVisible
                      ? borderRadius.subtract(
                          const BorderRadius.only(bottomRight: radius))
                      : BorderRadius.circular(25),
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
                          onCancel: onCancelEmojiKeyboard,
                          textEditingController: widget.textEditingController,
                        )
                      : const Icon(
                          Icons.emoji_emotions_outlined,
                          size: 35,
                          color: Colors.white,
                        ),
                )),
        isEmojiKeyboardVisible
            ? Container()
            : AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                height: isAnswerKeyboardVisible ? 250 : 45,
                width: isAnswerKeyboardVisible ? 300 : 170,
                duration: const Duration(milliseconds: 0),
                margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                decoration: BoxDecoration(
                  color: PeerPALAppColor.primaryColor,
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
                        ? ChatAnswerKeyboard(widget.appUserPhoneNumber,
                            onCancel: onCancelAnswerKeyboard,
                            textEditingController: widget.textEditingController)
                        : const Center(
                            child: Text(
                            'Antwort wählen',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )))),
      ],
    );
  }
}
