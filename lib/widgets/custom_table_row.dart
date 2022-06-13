import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

// ignore: must_be_immutable
class CustomTableRow extends StatelessWidget {
  String? text;
  VoidCallback? onPressed;
  bool isArrowVisible;

  CustomTableRow({this.text, this.onPressed, this.isArrowVisible = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: secondaryColor))),
      child: TextButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: CustomPeerPALHeading3(
                  text: text!,
                  color: Colors.black,
                ),
              ),
              isArrowVisible
                  ? Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: secondaryColor,
                    )
                  : Container(),
            ],
          ),
          style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ))),
    );
  }
}
