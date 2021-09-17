import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPeerPALText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;


  CustomPeerPALText({this.text, this.fontSize, this.color, this.fontWeight, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight, fontFamily: 'CustomPeerPalFontFamily'),
      textAlign: textAlign,
    );
  }
}
