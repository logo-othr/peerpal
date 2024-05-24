import 'package:flutter/material.dart';
import 'package:peerpal/app/data/resources/colors.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class FriendRequestButtonLayout extends StatelessWidget {
  final String buttonText;
  final Widget actionWidget;

  const FriendRequestButtonLayout({
    required this.buttonText,
    required this.actionWidget,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: PeerPALAppColor.secondaryColor),
        ),
      ),
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
          actionWidget,
        ],
      ),
    );
  }
}
