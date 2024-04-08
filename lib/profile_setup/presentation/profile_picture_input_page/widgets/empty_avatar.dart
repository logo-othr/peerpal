import 'package:flutter/material.dart';
import 'package:peerpal/app/data/resources/colors.dart';

class EmptyAvatar extends StatelessWidget {
  final Icon icon;

  const EmptyAvatar({
    Key? key,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 150.0,
        height: 150.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: PeerPALAppColor.primaryColor,
            width: 4.0,
          ),
        ),
        child: Icon(
          Icons.camera_alt_outlined,
          size: 110,
          color: PeerPALAppColor.primaryColor,
        ));
  }
}
