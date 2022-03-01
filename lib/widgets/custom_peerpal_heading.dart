import 'package:flutter/material.dart';
import 'package:peerpal/widgets/custom_peerpal_text.dart';

class CustomPeerPALHeading1 extends StatelessWidget {
  String text;

  CustomPeerPALHeading1(this.text);

  @override
  Widget build(BuildContext context) {
    return CustomPeerPALText(
      text: text,
      fontSize: 25,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      textAlign: TextAlign.center
    );
  }
}

class CustomPeerPALHeading2 extends StatelessWidget {
  String text;
  Color? color;
  TextAlign? textAlign;

  CustomPeerPALHeading2(this.text, {this.color, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return CustomPeerPALText(
      text: text,
      fontSize: 22,
      color: color,
      fontWeight: FontWeight.bold,
      textAlign: textAlign,
    );
  }
}

class CustomPeerPALHeading3 extends StatelessWidget {
  double? fontSize = 16;
  FontWeight? fontWeight = FontWeight.normal;
  String text;
  Color? color;

  CustomPeerPALHeading3(
      {required this.text, this.color, this.fontWeight, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return CustomPeerPALText(
      text: text,
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }
}

class CustomPeerPALHeading4 extends StatelessWidget {
  String text;
  Color? color;
  TextAlign? alignment;

  CustomPeerPALHeading4(this.text, {this.color, this.alignment});

  @override
  Widget build(BuildContext context) {
    return CustomPeerPALText(
      text: text, fontSize: 14, color: color, fontWeight: FontWeight.normal, textAlign: alignment,);
  }
}

