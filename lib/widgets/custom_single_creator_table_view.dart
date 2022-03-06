import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

import '../../colors.dart';



// ignore: must_be_immutable
class CustomSingleCreatorTable extends StatelessWidget {
  String? heading;
  String? text;
  VoidCallback? onPressed;
  IconData? tapIcon;
  ImageProvider avatar;

  CustomSingleCreatorTable({this.heading, this.text, this.onPressed, this.tapIcon, required this.avatar});

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
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
                child:
                CustomPeerPALHeading3(text:heading!, color: secondaryColor),
              ),
              Container(
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(width: 1, color: secondaryColor),
                        bottom: BorderSide(width: 1, color: secondaryColor))),
                child: TextButton(
                    onPressed: onPressed,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:  avatar,
                                backgroundColor: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: text!,
                                        style: textStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,10,0),
                          child: Icon(
                            tapIcon,
                            size: 30,
                            color: primaryColor,
                          ),
                        ),
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
