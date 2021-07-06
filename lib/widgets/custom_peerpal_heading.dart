import 'package:flutter/material.dart';
import 'package:peerpal/widgets/custom_peerpal_text.dart';

// ignore: must_be_immutable
class CustomPeerPALHeading1 extends StatelessWidget {

  String text;

  CustomPeerPALHeading1(this.text);

  @override
  Widget build(BuildContext context) {
    return CustomPeerPALText(text: text, fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold,);
  }
}

// ignore: must_be_immutable
class CustomPeerPALHeading2 extends StatelessWidget {

  String text;
  Color? color;
  TextAlign? textAlign;
  CustomPeerPALHeading2(this.text, {this.color, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return CustomPeerPALText(text: text, fontSize: 22, color: color, fontWeight: FontWeight.bold, textAlign: textAlign,);

  }
}

// ignore: must_be_immutable
class CustomPeerPALHeading3 extends StatelessWidget {

  String text;
  Color? color;

  CustomPeerPALHeading3(this.text, {this. color});

  @override
  Widget build(BuildContext context) {
    return CustomPeerPALText(text: text, fontSize: 16, color: color, fontWeight: FontWeight.normal,);
  }
}

// ignore: must_be_immutable
class CustomPeerPALHeading4 extends StatelessWidget {

  String text;
  Color? color;

  CustomPeerPALHeading4(this.text, {this. color});

  @override
  Widget build(BuildContext context) {
    return CustomPeerPALText(text: text, fontSize: 14, color: color, fontWeight: FontWeight.normal);
  }
}