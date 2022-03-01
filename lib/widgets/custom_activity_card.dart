import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peerpal/repository/activity_icon_data..dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/custom_peerpal_text.dart';


import '../../colors.dart';

// ignore: must_be_immutable
class CustomActivityCard extends StatefulWidget {
  Activity activity;
  bool isOwnCreatedActivity = false;

  CustomActivityCard({required this.activity});

  @override
  _CustomActivityCardState createState() => _CustomActivityCardState();
}

class _CustomActivityCardState extends State<CustomActivityCard> {
  bool _expanded = false;

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
                                  ActivityIconData
                                      .icons[widget.activity.code],
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
                            widget.activity.name!,
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
                                CustomPeerPALHeading3(text: widget.activity.creatorName ?? ''),
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
                                CustomPeerPALHeading3(text: (DateFormat('dd.mm.yyyy').format(widget.activity.date!))
                                    ),
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
                                CustomPeerPALHeading3(text: widget.activity.location?.place ?? ''),
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
                                CustomPeerPALHeading3(text: widget.activity.attendeeIds?.length.toString() ?? ''),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),

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
                            text:widget.activity.description ?? ''),
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
