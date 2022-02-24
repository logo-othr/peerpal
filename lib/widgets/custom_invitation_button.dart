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
        required this.header})
      : super(key: key);
  String length;
  String text;
  IconData icon;
  String header;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80,
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
                  size: 30,
                ),
              ),
              CustomPeerPALHeading2(text, color: primaryColor),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child:  Padding(
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
        SizedBox(
          height: 40,
          child: Center(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child:
                CustomPeerPALHeading3(text: header, color: secondaryColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
