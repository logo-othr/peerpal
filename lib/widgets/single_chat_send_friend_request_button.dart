import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

import 'package:peerpal/widgets/custom_peerpal_heading.dart';

import 'package:provider/src/provider.dart';

// ignore: must_be_immutable
class SingleChatSendFriendRequestButton extends StatelessWidget {
  SingleChatSendFriendRequestButton({ required this.buttonText, required this.onPressed});

  String buttonText;
  VoidCallback onPressed;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            border:
            Border(bottom: BorderSide(width: 1, color: secondaryColor))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 25, 0),
                  child: Icon(
                    Icons.person_add,
                    color: primaryColor,
                    size: 25,
                  ),
                ),
                CustomPeerPALHeading3(
                  text: buttonText,
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}