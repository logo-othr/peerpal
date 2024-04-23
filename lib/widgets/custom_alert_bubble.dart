import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomAlertBubble extends StatelessWidget {
  String? text;

  CustomAlertBubble({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleAvatar(
        radius: 11,
        child: Text(text!, style: TextStyle(color: Colors.white, fontSize: 12)),
        backgroundColor: Colors.red,
      ),
    );
  }
}
