import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomPeerPALText extends StatelessWidget {
  String text = "";
  double fontSize;
  FontWeight fontWeight;
  Color color;
  TextAlign textAlign;


  CustomPeerPALText({this.text, this.fontSize, this.color, this.fontWeight, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight, fontFamily: "CustomPeerPalFontFamily"),
      textAlign: textAlign,
    );
  }
}
