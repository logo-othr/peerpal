import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

import '../../colors.dart';

class CustomActivityOverviewHeaderCard extends StatelessWidget {
  CustomActivityOverviewHeaderCard(
      {required this.heading,
      required this.icon,
      required this.isActive,
      required this.onActive,
      required this.onInactive});

  final IconData icon;
  final String heading;
  final VoidCallback onActive;
  final VoidCallback onInactive;
  final bool isActive;

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: secondaryColor))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
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
                          color: primaryColor,
                          width: 2.0,
                        ),
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  CustomPeerPALHeading2(heading),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                    height: 115,
                    child:
                        VerticalDivider(thickness: 1, color: secondaryColor)),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CustomPeerPALHeading4('ÖFFENTLICH'),
                      Switch(
                        value: isActive,
                        onChanged: (value) async {
                          if (isActive) {
                            onActive();
                          } else {
                            onInactive();
                          }
                        },
                        activeTrackColor: secondaryColor,
                        activeColor: primaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
