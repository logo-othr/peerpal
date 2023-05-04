import 'package:flutter/material.dart';
import 'package:peerpal/app/data/resources/colors.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

// ignore: must_be_immutable
class CancelFriendRequestButton extends StatelessWidget {
  CancelFriendRequestButton(
      {required this.buttonText, required this.onPressed});

  String buttonText;
  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom:
                  BorderSide(width: 1, color: PeerPALAppColor.secondaryColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 25, 0),
                child: Icon(
                  Icons.person_add,
                  color: PeerPALAppColor.primaryColor,
                  size: 25,
                ),
              ),
              CustomPeerPALHeading3(
                text: buttonText,
                color: PeerPALAppColor.primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                  minimumSize: const Size(50, 20),
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(0)),
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Abbrechen',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
