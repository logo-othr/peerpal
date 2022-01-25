import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class CustomCupertinoSearchBar extends StatelessWidget {
  String? heading = "";

  CustomCupertinoSearchBar({this.heading});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heading == null
              ? Container()
              : Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: CustomPeerPALHeading1(heading!),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: CupertinoSearchTextField(
              placeholder: "Suchen",
            ),
          )
        ],
      ),
    );
  }
}
