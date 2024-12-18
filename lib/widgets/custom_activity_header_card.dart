import 'package:flutter/material.dart';

import '../app/data/resources/colors.dart';
import 'custom_peerpal_heading.dart';

// ignore: must_be_immutable
class CustomActivityHeaderCard extends StatelessWidget {
  final IconData icon;
  final String activity;

  CustomActivityHeaderCard({required this.icon, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top:
                    BorderSide(width: 1, color: PeerPALAppColor.secondaryColor),
                bottom: BorderSide(
                    width: 1, color: PeerPALAppColor.secondaryColor))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Container(
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
                        color: PeerPALAppColor.primaryColor,
                        width: 2.0,
                      ),
                    )),
                SizedBox(
                  width: 20,
                ),
                CustomPeerPALHeading2(activity),
              ],
            ),
          ),
        ));
  }
}
