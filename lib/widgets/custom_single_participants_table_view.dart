import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../colors.dart';
import 'custom_activity_participations_dialog.dart';
import 'custom_peerpal_heading.dart';


// ignore: must_be_immutable
class CustomSingleParticipantsTable extends StatelessWidget {
  String? heading;
  String? text;
  VoidCallback? onPressed;
  final bool isOwnCreatedActivity;


  CustomSingleParticipantsTable({this.heading, this.text,  this.onPressed, required this.isOwnCreatedActivity});


  List<String> userNames = ["Xaver", "Max Mustermann", "Maxime Musterfrau", "Tim", "Günther Schuhmann"];

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
                CustomPeerPALHeading3(text:heading!, color: secondaryColor),
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
                          child:
                          CustomPeerPALHeading3(text:text!, color: Colors.black,),
                        ),
                        GestureDetector(
                          onTap: () {
                          userNames.sort();
                            showDialog(context: context,
                                builder: (BuildContext context){
                                  return   CustomActivityParticipationsDialog(isOwnCreatedActivity: isOwnCreatedActivity, userNames: userNames);
                                }
                            );

                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: secondaryColor,
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
