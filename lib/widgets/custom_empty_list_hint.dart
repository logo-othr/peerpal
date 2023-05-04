import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

import '../app/data/resources/colors.dart';

// ignore: must_be_immutable
class CustomEmptyListHint extends StatelessWidget {
  IconData? icon;
  String? text;

  CustomEmptyListHint({this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: PeerPALAppColor.secondaryColor, size: 60),
        SizedBox(height: 20),
        CustomPeerPALHeading2(
          text!,
          color: PeerPALAppColor.secondaryColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
