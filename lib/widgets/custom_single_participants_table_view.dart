import 'package:flutter/material.dart';

import '../app/data/resources/colors.dart';
import 'custom_peerpal_heading.dart';

// ignore: must_be_immutable
class CustomSingleParticipantsTable extends StatelessWidget {
  String? heading;
  String? text;
  VoidCallback? onPressed;
  final bool isArrowIconVisible;

  CustomSingleParticipantsTable(
      {this.heading,
      this.text,
      this.onPressed,
      required this.isArrowIconVisible});

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
                child: CustomPeerPALHeading3(
                    text: heading!, color: PeerPALAppColor.secondaryColor),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(
                            width: 1, color: PeerPALAppColor.secondaryColor),
                        bottom: BorderSide(
                            width: 1, color: PeerPALAppColor.secondaryColor))),
                child: TextButton(
                    onPressed: onPressed,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                        ),
                        isArrowIconVisible
                            ? Icon(
                          Icons.arrow_forward_ios,
                                size: 15,
                                color: PeerPALAppColor.secondaryColor,
                              )
                            : Container(),
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
