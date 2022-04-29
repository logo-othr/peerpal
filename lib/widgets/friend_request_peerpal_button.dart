import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';

class FriendRequestPeerPALButton extends StatelessWidget {
  FriendRequestPeerPALButton(
      {required this.buttonText, required this.onPressed, required this.color});

  String buttonText;
  VoidCallback onPressed;
  Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPeerPALButton(
      text: buttonText, color: color, onPressed: onPressed,);
  }
}