import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/resources/colors.dart';
import 'custom_peerpal_heading.dart';

// ignore: must_be_immutable
class CustomSingleTable extends StatelessWidget {
  String? heading;
  String? text;
  VoidCallback? onPressed;
  bool? isArrowIconVisible = true;

  CustomSingleTable(
      {this.heading, this.text, this.onPressed, this.isArrowIconVisible});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                child: CustomPeerPALHeading3(
                    text: heading!, color: secondaryColor),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(width: 1, color: secondaryColor),
                        bottom: BorderSide(width: 1, color: secondaryColor))),
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
                        isArrowIconVisible!
                            ? Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: secondaryColor,
                              )
                            : Container()
                      ],
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
