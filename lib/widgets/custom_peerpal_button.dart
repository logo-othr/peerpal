import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/widgets/custom_peerpal_text.dart';

class CustomPeerPALButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
final Color? color;
  CustomPeerPALButton({ required this.text, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        key: key,
        onPressed: onPressed,
        child: CustomPeerPALText(
          text: text,
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
        style: TextButton.styleFrom(
          minimumSize: Size(300, 45),
          backgroundColor: color == null ? primaryColor : color,
          padding: EdgeInsets.all(0),
        ));
  }
}

class CustomPeerPALButton2 extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;

  CustomPeerPALButton2({ required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        key: key,
        onPressed: onPressed,
        child: CustomPeerPALText(
          text: text,
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
        style: TextButton.styleFrom(
          minimumSize: Size(170, 45),
          backgroundColor: Color.fromRGBO(0, 0, 0, 1.0),
          padding: EdgeInsets.all(10),
        ));
  }
}