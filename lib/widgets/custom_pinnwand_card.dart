import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/custom_peerpal_text.dart';


import '../../colors.dart';

// ignore: must_be_immutable
class CustomPinnwandCard extends StatefulWidget {
  bool isOwnCreatedActivity = false;
  String? name;

  CustomPinnwandCard({required this.isOwnCreatedActivity,required String? name});

  @override
  _CustomPinnwandCardState createState() => _CustomPinnwandCardState();
}

class _CustomPinnwandCardState extends State<CustomPinnwandCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
                width: widget.isOwnCreatedActivity ? 2 : 1,
                color: widget.isOwnCreatedActivity
                    ? primaryColor
                    : secondaryColor),
            boxShadow: [
              BoxShadow(
                color: secondaryColor,
                blurRadius: 2.0,
                spreadRadius: 0.0,
                offset: Offset(2.0, 2.0), // shadow direction: bottom right
              )
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                                width: widget.isOwnCreatedActivity ? 2 : 1,
                                color: widget.isOwnCreatedActivity
                                    ? primaryColor
                                    : secondaryColor))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                          child: Container(
                              child: CircleAvatar(
                                radius: 30,
                                child: Icon(
                                  Icons.directions_bike,
                                  size: 40,
                                  color: Colors.black,
                                ),
                                backgroundColor: Colors.white,
                              ),
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                border: new Border.all(
                                  color: primaryColor,
                                  width: 2.0,
                                ),
                              )),
                        ),
                        Center(
                          child: CustomPeerPALHeading2(
                            "Radfahren",
                            color: primaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: widget.isOwnCreatedActivity
                              ? Icon(
                                  Icons.edit,
                                  color: primaryColor,
                                  size: 30,
                                )
                              : Container(
                                  width: 30,
                                ),
                        )
                      ],
                    )),
              ),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                              width: widget.isOwnCreatedActivity ? 2 : 1,
                              color: widget.isOwnCreatedActivity
                                  ? primaryColor
                                  : secondaryColor))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CustomPeerPALHeading3(
                                  fontWeight: FontWeight.bold,
                                  text:"Ersteller: "
                                ),
                                SizedBox(width: 5),
                                CustomPeerPALHeading3(text: "Sabrina Müller"),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                CustomPeerPALHeading3(
                                  text: "Datum: ",
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(width: 5),
                                CustomPeerPALHeading3(text: "01.09.2021"),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                CustomPeerPALHeading3(
                                 text: "Ort: ",
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(width: 5),
                                CustomPeerPALHeading3(text: "Regensburg"),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                CustomPeerPALHeading3(
                                  text: "Teilnehmer: ",
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(width: 5),
                                CustomPeerPALHeading3(text: "2"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                        child: TextButton(
                            onPressed: () => {
                                  //do something
                                },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 5),
                                CustomPeerPALText(
                                  text: "Info",
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ],
                            ),
                            style: TextButton.styleFrom(
                              minimumSize: Size(80, 45),
                              backgroundColor: primaryColor,
                              padding: EdgeInsets.all(0),
                            )),
                      ),
                    ],
                  )),
              ExpansionPanelList(
                animationDuration: Duration(milliseconds: 500),
                children: [
                  ExpansionPanel(
                    backgroundColor: Colors.white,
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                          title: _expanded
                              ? CustomPeerPALHeading3(text:'Beschreibung ausblenden',
                                  color: primaryColor, fontWeight: FontWeight.bold,)
                              : CustomPeerPALHeading3(text:'Beschreibung anzeigen',
                                  color: primaryColor, fontWeight: FontWeight.bold,));
                    },
                    body: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                        child: CustomPeerPALHeading3(
                            text:'Gemütliches Radfahren entlang der Donau. Die Strecke ist ca. 20 Kilometer lang und essind 2 Pausen eingeplant.'),
                      ),
                    ),
                    isExpanded: _expanded,
                    canTapOnHeader: true,
                  ),
                ],
                expansionCallback: (panelIndex, isExpanded) {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ],
          )),
    );
  }
}
