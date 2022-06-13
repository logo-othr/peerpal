import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_peerpal_heading.dart';

// ignore: must_be_immutable
class CustomPeerPALRequestButton extends StatelessWidget {
  String? text;
  IconData? icon;
  Color? buttonColor;
  VoidCallback? onPressed;

  CustomPeerPALRequestButton(
      {this.text, this.icon, this.buttonColor, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.white),
            SizedBox(width: 10),
            CustomPeerPALHeading4(text!, color: Colors.white),
          ],
        ),
        style: TextButton.styleFrom(
          minimumSize: Size(120, 20),
          backgroundColor: buttonColor,
        ));
  }
}
