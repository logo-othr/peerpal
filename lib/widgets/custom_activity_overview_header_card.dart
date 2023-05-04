import 'package:flutter/material.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

import '../app/data/resources/colors.dart';

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
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    width: 1, color: PeerPALAppColor.secondaryColor))),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              Container(
                width: 120,
                child: CustomPeerPALHeading3(
                    fontSize: MediaQuery.of(context).size.width / 21,
                    fontWeight: FontWeight.bold,
                    text: heading),
              ),
              //CustomPeerPALHeading2(heading),
              VerticalDivider(
                  thickness: 1, color: PeerPALAppColor.secondaryColor),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    child: CustomPeerPALHeading4('ÖFFENTLICH'),
                  ),
                  //CustomPeerPALHeading4(),
                  Switch(
                    value: isActive,
                    onChanged: (value) async {
                      if (value) {
                        onActive();
                      } else {
                        onInactive();
                      }
                    },
                    activeTrackColor: PeerPALAppColor.secondaryColor,
                    activeColor: PeerPALAppColor.primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
