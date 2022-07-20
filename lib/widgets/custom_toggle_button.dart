import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/data/resources/colors.dart';
import 'package:peerpal/widgets/custom_peerpal_text.dart';

class CustomToggleButton extends StatelessWidget {
  bool communicationButtonActive = false;
  String? text;
  Color? textColor;
  double? width;
  double? height;
  VoidCallback? onPressed;
  bool active;

  CustomToggleButton(
      {this.text,
      required this.textColor,
      required this.height,
      required this.width,
      required this.onPressed,
      required this.active});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          minimumSize: Size(width!, height!),
          backgroundColor: active ? Colors.green : secondaryColor,
          padding: EdgeInsets.all(0),
        ),
        child: CustomPeerPALText(
          text: text,
          fontSize: 18,
          color: textColor,
          fontWeight: FontWeight.normal,
        ));
  }
}
