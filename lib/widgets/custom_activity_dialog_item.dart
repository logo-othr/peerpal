import 'package:flutter/material.dart';

import '../data/resources/colors.dart';
import 'custom_peerpal_heading.dart';

class CustomActivityDialogItem extends StatefulWidget {
  final String name;
  final bool isOwnCreatedActivity;

  const CustomActivityDialogItem(
      {required this.name, required this.isOwnCreatedActivity});

  @override
  _CustomActivityDialogItemState createState() =>
      _CustomActivityDialogItemState();
}

class _CustomActivityDialogItemState extends State<CustomActivityDialogItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomPeerPALHeading3(
                  text: widget.name,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: widget.isOwnCreatedActivity
                  ? GestureDetector(
                      onTap: () {}, child: Icon(Icons.cancel_outlined))
                  : Container(),
            )
          ],
        ));
  }
}
