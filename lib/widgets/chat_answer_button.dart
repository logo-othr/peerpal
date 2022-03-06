import 'package:flutter/material.dart';

class ChatAnswerKeyboard extends StatefulWidget {
  VoidCallback onCancel;
  final TextEditingController textEditingController;

  ChatAnswerKeyboard({
    required this.onCancel, required this.textEditingController
  });

  @override
  State<ChatAnswerKeyboard> createState() => _ChatAnswerKeyboardState();
}

void addStringToTextController(
    TextEditingController controller, String string) {
  String currentText = controller.text.toString();
  String updatedText = "${currentText}${string}";
  controller.text = updatedText;
  controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length));
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
                customAnswerListTile(widget.textEditingController, 'Möchten Sie telefonieren?'),
                customAnswerListTile(widget.textEditingController, 'Ja'),
                customAnswerListTile(widget.textEditingController, 'Nein'),
                customAnswerListTile(widget.textEditingController, 'Hallo'),
                customAnswerListTile(widget.textEditingController, 'Wie geht es Ihnen?'),
                customAnswerListTile(widget.textEditingController, 'Möchten Sie etwas unternehmen?'),
                customAnswerListTile(widget.textEditingController, 'Danke'),
                customAnswerListTile(widget.textEditingController, 'Gern geschehen'),
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
            child: Text(
              'Abbrechen',
              style: TextStyle(
                color: Colors.white,
              ),
            )),
      ],
    ),
  );
}

Widget customAnswerListTile(textEditingController, text) => Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              addStringToTextController(textEditingController, text);
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              width: double.infinity,
              height: 50,
              child: Text(
                text,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                ),
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
