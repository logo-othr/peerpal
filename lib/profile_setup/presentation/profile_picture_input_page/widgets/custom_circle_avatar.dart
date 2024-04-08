import 'package:flutter/material.dart';
import 'package:peerpal/app/data/resources/colors.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({Key? key, required this.image}) : super(key: key);

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      height: 150.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: image,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: PeerPALAppColor.primaryColor,
          width: 4.0,
        ),
      ),
    );
  }
}
