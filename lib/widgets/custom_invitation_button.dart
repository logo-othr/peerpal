import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class CustomInvitationButton extends StatelessWidget {
  CustomInvitationButton(
      {Key? key,
        required this.length,
        required this.text,
        required this.icon,
        this.header,
        this.small = false,
        this.badgeColor = Colors.red})
      : super(key: key);
  final String length;
  final String text;
  final IconData icon;
  final String? header;
  final bool small;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: small ? 60 : 80,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(width: 1, color: secondaryColor),
                  bottom: BorderSide(width: 1, color: secondaryColor))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Icon(
                  icon,
                  color: primaryColor,
                  size: small? 22: 30,
                ),
              ),
              small? CustomPeerPALHeading3(text: text, fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor,) : CustomPeerPALHeading2(text, color: primaryColor),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: badgeColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Text(
                      length,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        header != null
            ? SizedBox(
          height: 40,
          child: Center(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: CustomPeerPALHeading3(
                    text: header!, color: secondaryColor),
              ),
            ),
          ),
        )
            : Container(),
      ],
    );
  }
}
