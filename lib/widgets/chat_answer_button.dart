import 'package:flutter/material.dart';

class ChatAnswerKeyboard extends StatefulWidget {
  VoidCallback onCancel;
  final TextEditingController textEditingController;
  //VoidCallback onPressedAnswerKeyboardItem;

  ChatAnswerKeyboard({
    required this.onCancel, required this.textEditingController
    /*required this.onPressedAnswerKeyboardItem*/
  });

  @override
  State<ChatAnswerKeyboard> createState() => _ChatAnswerKeyboardState();
}

class _ChatAnswerKeyboardState extends State<ChatAnswerKeyboard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        customAnswerHeaderBar(widget.onCancel),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                customAnswerListTile('Deine Telefonnummer senden'),
                customAnswerListTile('Ja'),
                customAnswerListTile('Nein'),
                customAnswerListTile('Vielleicht'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget customAnswerHeaderBar(onCancel) {
  return Container(
    padding: const EdgeInsets.all(15),
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
        const Text(
          'Antwort wählen',
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
            fontWeight: FontWeight.bold,
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

Widget customAnswerListTile(text) => Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const Divider(
            height: 3,
            color: Colors.white,
          )
        ],
      ),
    );
