import 'package:flutter/material.dart';
import 'package:peerpal/app/data/resources/colors.dart';

import 'custom_peerpal_heading.dart';

class CustomSingleTable extends StatelessWidget {
  const CustomSingleTable(
      {required this.heading,
      required this.text,
      this.onPressed,
      this.isArrowIconVisible = true});

  final String heading;
  final String text;
  final VoidCallback? onPressed;
  final bool isArrowIconVisible;

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
                    text: heading, color: PeerPALAppColor.secondaryColor),
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
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        )),
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
                                    text: text,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                      color: Colors.black,
                                    ),
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
                            : Container()
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
