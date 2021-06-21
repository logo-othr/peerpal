import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/widgets/custom_peerpal_text.dart';

// ignore: must_be_immutable
class CustomPeerPALButton extends StatelessWidget {
  String? text;
  VoidCallback? onPressed;

  CustomPeerPALButton({required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child:
        CustomPeerPALText(text: text, fontSize: 18, color: Colors.white, fontWeight: FontWeight.normal,),
        style: TextButton.styleFrom(
          minimumSize: Size(300, 45),
          backgroundColor: primaryColor,
          padding: EdgeInsets.all(0),
        ));
  }
}
