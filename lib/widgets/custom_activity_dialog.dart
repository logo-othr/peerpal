import 'package:flutter/material.dart';
import 'package:peerpal/widgets/custom_activity_dialog_item.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

import '../../colors.dart';

class Person {
  String name;

  Person({required this.name});
}

class CustomActivityDialog extends StatefulWidget {
  final bool isOwnCreatedActivity;
  final List<String>? activities;

  const CustomActivityDialog(
      {required this.isOwnCreatedActivity, this.activities});

  @override
  _CustomActivityDialogState createState() => _CustomActivityDialogState();
}

class _CustomActivityDialogState extends State<CustomActivityDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2, color: primaryColor),
          borderRadius: BorderRadius.circular(10)),
      height: 300,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(width: 1, color: primaryColor))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 0, 10),
                    child: CustomPeerPALHeading1("Aktivitäten"),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 15, 10),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: CustomPeerPALHeading4("Schließen")),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var entry in widget.activities!)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                          child: CustomActivityDialogItem(
                              name: entry,
                              isOwnCreatedActivity:
                                  widget.isOwnCreatedActivity),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
