
import 'package:flutter/material.dart';

import '../colors.dart';
import 'custom_peerpal_heading.dart';


class CustomActivityParticipationsDialogItem extends StatefulWidget {

  final String name;
  final bool isOwnCreatedActivity;
  const CustomActivityParticipationsDialogItem({required this.name, required this.isOwnCreatedActivity});

  @override
  _CustomActivityParticipationsDialogItemState createState() => _CustomActivityParticipationsDialogItemState();
}

class _CustomActivityParticipationsDialogItemState extends State<CustomActivityParticipationsDialogItem> {
  @override
  Widget build(BuildContext context) {
    return  Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomPeerPALHeading3(text:widget.name,fontWeight: FontWeight.bold,color: primaryColor),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,10,0),
              child: widget.isOwnCreatedActivity? GestureDetector(
                  onTap: () {

                  },
                  child: Icon(Icons.cancel_outlined)) : Container(),
            )
          ],
        ));


  }
}