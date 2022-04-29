import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/custom_peerpal_request_button.dart';

import '../../colors.dart';


// ignore: must_be_immutable
class CustomActivityRequestCard extends StatelessWidget {
  String? heading;
  String? activity;
  String? time;
  IconData? icon;

  CustomActivityRequestCard({ this.heading,  this.activity,  this.time,  this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: secondaryColor))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    child: Container(
                        child: CircleAvatar(
                          radius: 35,
                          child: Icon(
                            icon,
                            size: 50,
                            color: Colors.black,
                          ),
                          backgroundColor: Colors.white,
                        ),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: new Border.all(
                            color: primaryColor,
                            width: 2.0,
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomPeerPALHeading2(heading!, color: primaryColor),
                        SizedBox(height: 5),
                        CustomPeerPALHeading3(color: primaryColor, text: activity!),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            CustomPeerPALHeading3(color: Colors.black, text: 'Uhrzeit:',),
                            SizedBox(width: 5),
                            CustomPeerPALHeading3(color: Colors.black, text:time!),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            CustomPeerPALRequestButton(
                              text: "Annehmen",
                              icon: Icons.check,
                              buttonColor: Colors.green,
                            ),
                            SizedBox(width: 10),
                            CustomPeerPALRequestButton(
                              text: "Ablehnen",
                              icon: Icons.cancel_outlined,
                              buttonColor: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
