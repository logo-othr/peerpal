import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';

import '../data/resources/colors.dart';

class CustomDialog extends StatefulWidget {
  CustomDialog(
      {required this.onPressed,
      required this.dialogText,
      required this.actionButtonText,
      required this.dialogHeight});

  VoidCallback? onPressed;
  String dialogText;
  String actionButtonText;
  double? dialogHeight;

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
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
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2, color: PeerPALAppColor.primaryColor),
          borderRadius: BorderRadius.circular(10)),
      height: widget.dialogHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.dialogText,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
            child: CustomPeerPALButton(
                onPressed: () {
                  widget.onPressed!();
                  Navigator.pop(context);
                },
                text: widget.actionButtonText),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
            child: CustomPeerPALButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: 'Abbrechen'),
          )
        ],
      ),
    );
  }
}
