import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';


// ignore: must_be_immutable
class CustomSingleLocationTable extends StatelessWidget {
  String? heading;
  String? text;
  String? subText;
  VoidCallback? onPressed;
  final bool isArrowIconVisible;



  CustomSingleLocationTable({this.heading, this.text, this.subText, this.onPressed, required this.isArrowIconVisible});


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
                child:
                CustomPeerPALHeading3(text: heading!, color: secondaryColor),
              ),
              Container(
                height: 55,
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
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child:
                              CustomPeerPALHeading3(text:text!, color: Colors.black,),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: CustomPeerPALHeading4(subText!, color: Colors.black,),
                            ),
                          ],
                        ),
                        isArrowIconVisible? Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: secondaryColor,
                        ) : Container(),
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
