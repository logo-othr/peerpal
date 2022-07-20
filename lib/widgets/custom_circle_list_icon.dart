import 'package:flutter/material.dart';
import 'package:peerpal/data/resources/colors.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class CustomCircleListItem extends StatelessWidget {
  String label;
  IconData? icon;
  bool active;

  CustomCircleListItem({required this.label, this.icon, required this.active});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: active ? Colors.green : primaryColor,
                width: 2.0,
              ),
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(
                icon,
                size: 50,
                color: Colors.black,
              ),
            )),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Center(
              child: Container(
            width: 100,
            child: CustomPeerPALHeading4(label,
                color: active ? Colors.green : primaryColor,
                alignment: TextAlign.center),
          )),
        ),
      ],
    );
  }
}
