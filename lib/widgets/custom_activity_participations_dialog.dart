import 'dart:collection';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:peerpal/widgets/custom_activity_dialog_item.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

import '../../colors.dart';


class Person {
  String name;

  Person({required this.name});
}

class CustomActivityParticipationsDialog extends StatefulWidget {
  final bool isOwnCreatedActivity;
  final List<String?>? userNames;

  const CustomActivityParticipationsDialog(
      {required this.isOwnCreatedActivity,  this.userNames});

  @override
  _CustomActivityParticipationsDialogState createState() =>
      _CustomActivityParticipationsDialogState();
}

class _CustomActivityParticipationsDialogState
    extends State<CustomActivityParticipationsDialog> {
  final list = [
    Person(name: "Xaver"),
    Person(name: "Andreas Rothballer"),
    Person(name: "Daniel Kreiter"),
    Person(name: "Tim"),
    Person(name: "Günther Schuhmann"),
    Person(name: "Alexandra"),
    Person(name: "Alex"),
  ];

  final Map<String, List<Person>> groupedLists = {};

  void groupMyList() {
    list.sort((a, b) => a.name.compareTo(b.name));
    list.forEach((person) {
      if (groupedLists['${person.name[0]}'] == null) {
        groupedLists['${person.name[0]}'] = <Person>[];
      }

      groupedLists['${person.name[0]}']!.add(person);
    });
  }

  @override
  Widget build(BuildContext context) {
    groupMyList();
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
          border: Border.all(width: 2, color: primaryColor), borderRadius: BorderRadius.circular(10)),
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
                    child: CustomPeerPALHeading1("Teilnehmer"),
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
                      for (var entry in groupedLists.entries)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomPeerPALHeading3(text:entry.key,
                                fontWeight: FontWeight.bold),
                            SizedBox(height: 10),
                            Column(
                              children: [
                                for (int i = 0; i < entry.value.length; i++)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 0, 0, 10.0),
                                    child:
                                    CustomActivityDialogItem(
                                        name: entry.value[i].name,
                                        isOwnCreatedActivity:
                                        widget.isOwnCreatedActivity),
                                  ),
                              ],
                            ),
                          ],
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
