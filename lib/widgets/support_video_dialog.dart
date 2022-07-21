import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomSupportVideoDialog extends StatelessWidget {
  final String link;

  const CustomSupportVideoDialog({Key? key, required this.link})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SupportVideoDialog(
                infoText:
                    'Dieser Link wird Sie auf eine externe Seite weiterleiten, auf der sie das Video anschauen können.',
                dialogText:
                    "Um zum Hilfsvideo zu gelangen, klicken sie auf den folgenden Link.",
                onPressed: () => {Navigator.pop(context)},
                link: link,
                linkText: "Hilfsvideo",
              );
            }),
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: Icon(Icons.help_center, size: 30),
      ),
    );
  }
}

class SupportVideoDialog extends StatefulWidget {
  SupportVideoDialog(
      {required this.onPressed,
      required this.link,
      required this.dialogText,
      required this.infoText,
      required this.linkText});

  VoidCallback? onPressed;
  String dialogText;
  String link;
  String linkText;
  String infoText;

  @override
  _SupportVideoDialog createState() => _SupportVideoDialog();
}

class _SupportVideoDialog extends State<SupportVideoDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      insetPadding: EdgeInsets.all(60),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.dialogText,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RichText(
                    maxLines: 5,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                          text: widget.linkText,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightBlueAccent,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final Uri _url = Uri.parse(widget.link);
                              if (!await launchUrl(_url))
                                throw 'Could not open $_url';
                            })
                    ]),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.infoText,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ]),
          ),
          Divider(color: Colors.black),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
            child: TextButton(
              onPressed: widget.onPressed,
              child: Text('Abbrechen',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                    fontWeight: FontWeight.normal,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
