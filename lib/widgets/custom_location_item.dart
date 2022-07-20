import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/data/resources/colors.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

import '../data/location.dart';

class LocationItem extends StatelessWidget {
  const LocationItem(
      {required this.location,
      required this.iconBehavior,
      this.iconSize = 24,
      required this.iconColor,
      this.headingFontWeight = FontWeight.normal,
      this.headingFontSize = 16});

  final Location location;
  final IconData iconBehavior;
  final double iconSize;
  final Color iconColor;
  final FontWeight headingFontWeight;
  final double headingFontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: secondaryColor))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomPeerPALHeading3(
              text: location.place,
              fontWeight: headingFontWeight,
              fontSize: headingFontSize,
            ),
            Icon(
              iconBehavior,
              color: iconColor,
              size: iconSize,
            )
          ],
        ),
      ),
    );
  }
}
