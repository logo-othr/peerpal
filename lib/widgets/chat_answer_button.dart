import 'package:flutter/material.dart';
import 'package:peerpal/widgets/custom_dialog.dart';

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
          child: Scrollbar(
            isAlwaysShown: true,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                //todo: use item builder
                children: [
                  if (widget.appUserPhoneNumber != "")
                    customSendPhoneNumberListTile(
                        widget.textEditingController,
                        'Telefonnummer senden.',
                        context,
                        widget.appUserPhoneNumber),
                  customAnswerListTile(widget.textEditingController,
                      'Wie geht es Dir?', context),
                  customAnswerListTile(widget.textEditingController,
                      'Wollen wir telefonieren?', context),
                  customAnswerListTile(widget.textEditingController,
                      'Was hast du heute vor?', context),
                  customAnswerListTile(
                      widget.textEditingController, 'Hallo', context),
                  customAnswerListTile(
                      widget.textEditingController, 'Ja', context),
                  customAnswerListTile(
                      widget.textEditingController, 'Nein', context),
                  customAnswerListTile(
                      widget.textEditingController, 'Ok', context),
                  customAnswerListTile(
                      widget.textEditingController, 'Vielleicht', context),
                  customAnswerListTile(
                      widget.textEditingController, 'Gut', context),
                  customAnswerListTile(
                      widget.textEditingController, 'Schlecht', context),
                  customAnswerListTile(
                      widget.textEditingController, 'Gute Nacht', context),
                  customAnswerListTile(
                      widget.textEditingController, 'Tschüss', context),
                ],
              ),
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
                    fontSize: 22,
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

Widget customAnswerListTile(textEditingController, text, context) => Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
      child: GestureDetector(
        onTap: () {
          addStringToTextController(textEditingController, text);
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white))),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Text(
              text,
              maxLines: 3,
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width / 20,
              ),
            ),
          ),
        ),
      ),
    );

Widget customSendPhoneNumberListTile(
        textEditingController, text, context, appUserPhoneNumber) =>
    GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog(
                  dialogHeight: 300,
                  actionButtonText: 'Ja',
                  dialogText:
                      "Möchten Sie Ihre\nTelefonnummer:\n\n${appUserPhoneNumber}\n\n"
                      "wirklich senden?",
                  onPressed: () => {
                        addStringToTextController(
                            textEditingController, '${appUserPhoneNumber}'),
                      });
            });
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blueGrey,
            border: Border(bottom: BorderSide(color: Colors.white))),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Text(
            text,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width / 20,
            ),
          ),
        ),
      ),
    );