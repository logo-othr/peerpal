import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';
import 'package:peerpal/widgets/custom_dialog.dart';

import '../chat/presentation/chat/bloc/chat_page_bloc.dart';
import '../injection.dart';

class ChatAnswerKeyboard extends StatefulWidget {
  VoidCallback onCancel;
  final TextEditingController textEditingController;
  String? appUserPhoneNumber;


  ChatAnswerKeyboard(this.appUserPhoneNumber,
      {required this.onCancel, required this.textEditingController});

  @override
  State<ChatAnswerKeyboard> createState() => _ChatAnswerKeyboardState();
}

void addStringToTextController(
    TextEditingController controller, String string) {
  String currentText = controller.text.toString();
  String updatedText = "${currentText}${string}";
  controller.text = updatedText;
  controller.selection =
      TextSelection.fromPosition(TextPosition(offset: controller.text.length));
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
                customSendPhoneNumberListTile(
                    widget.textEditingController,
                    'Telefonnummer senden.',
                    context,
                    widget.appUserPhoneNumber),
                customAnswerListTile(
                    widget.textEditingController, 'Wie geht es Dir?'),
                customAnswerListTile(
                    widget.textEditingController, 'Wollen wir telefonieren?'),
                customAnswerListTile(
                    widget.textEditingController, 'Was hast du heute vor?'),
                customAnswerListTile(widget.textEditingController, 'Hallo'),
                customAnswerListTile(widget.textEditingController, 'Ja'),
                customAnswerListTile(widget.textEditingController, 'Nein'),
                customAnswerListTile(widget.textEditingController, 'Ok'),
                customAnswerListTile(
                    widget.textEditingController, 'Vielleicht'),
                customAnswerListTile(widget.textEditingController, 'Gut'),
                customAnswerListTile(widget.textEditingController, 'Schlecht'),
                customAnswerListTile(
                    widget.textEditingController, 'Gute Nacht'),
                customAnswerListTile(widget.textEditingController, 'Tschüss'),
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
            style: TextStyle(color: Colors.white, fontSize: 19),
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

Widget customSendPhoneNumberListTile(textEditingController, text, context,
    appUserPhoneNumber) =>
    Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(
                        dialogHeight: 300,
                        actionButtonText: 'Ja',
                        dialogText:
                        "Möchten Sie Ihre\nTelefonnummer:\n\n${appUserPhoneNumber}\n\nwirklich senden?",
                        onPressed: () => {
                          addStringToTextController(textEditingController, '${appUserPhoneNumber}'),
                        });
                  });
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              color: Colors.blueGrey,
              width: double.infinity,
              height: 50,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 19),
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
