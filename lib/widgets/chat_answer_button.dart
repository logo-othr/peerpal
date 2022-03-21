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

        Divider(
          thickness: 1,
          color: Colors.white,
        ),

        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Antwort wählen',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
                    const Text(
                      'Schließen',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              )),
        ),
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
                  fontSize: 19
                ),
              ),
            ),
          ),
          const Divider(
            height: 1,
            color: Colors.white,
          )
        ],
      ),
    );
