import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/repository/models/enum/communication_type.dart';

import 'custom_peerpal_heading.dart';

class CustomSingleTableWithListItems extends StatelessWidget {
  const CustomSingleTableWithListItems(
      {required this.heading,
      required this.list,
      required this.onPressed,
      this.isArrowIconVisible = true});

  final String heading;
  final List<String>? list;
  final VoidCallback onPressed;
  final bool isArrowIconVisible;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = new TextStyle(
      fontSize: 15,
      fontFamily: 'Roboto',
      color: Colors.black,
    );

    String items = "";
    if (list != null) items = list!.join(', ');

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
                    CustomPeerPALHeading3(text: heading, color: secondaryColor),
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
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Row(
                              children: [
                                ConstrainedBox(
                                  constraints: new BoxConstraints(
                                    maxWidth: 250,
                                  ),

                                  child: RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: items,
                                          style: textStyle,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        isArrowIconVisible
                            ? Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: secondaryColor,
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
