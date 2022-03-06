import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peerpal/activities/activity_overview_page/view/activity_overview_input_content.dart';
import 'package:peerpal/activities/activity_overview_page/view/activity_overview_input_page.dart';
import 'package:peerpal/repository/activity_icon_data..dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/custom_peerpal_text.dart';


import '../../colors.dart';

// ignore: must_be_immutable
class CustomActivityCard extends StatefulWidget {
  Activity activity;
  bool isOwnCreatedActivity = false;

  CustomActivityCard({required this.activity, required this.isOwnCreatedActivity});

  @override
  _CustomActivityCardState createState() => _CustomActivityCardState();
}

class _CustomActivityCardState extends State<CustomActivityCard> {
  bool _expanded = false;


  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
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
                        Flexible(
                          flex: 33,
                          child: Padding(
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
                        ),
                        Flexible(
                          flex: 33,
                          child: Center(
                            child: CustomPeerPALHeading2(
                              widget.activity.name!,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 33,
                          child: Padding(
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
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomPeerPALHeading3(
                              fontWeight: FontWeight.bold,
                              text:"Ersteller: "
                            ),
                            Flexible(
                              child: RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: widget.activity.creatorName ?? '',
                                      style: textStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //CustomPeerPALHeading3(text: widget.activity.creatorName ?? '', color: Colors.black,),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            CustomPeerPALHeading3(
                              text: "Datum: ",
                              fontWeight: FontWeight.bold,
                            ),
                            CustomPeerPALHeading3(text: (DateFormat('dd.MM.yyyy kk:mm').format(widget.activity.date!)), color: Colors.black)
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            CustomPeerPALHeading3(
                             text: "Ort: ",
                              fontWeight: FontWeight.bold,
                            ),
                            CustomPeerPALHeading3(text: widget.activity.location?.place ?? '', color: Colors.black,),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            CustomPeerPALHeading3(
                              text: "Teilnehmer: ",
                              fontWeight: FontWeight.bold,
                            ),
                            CustomPeerPALHeading3(text: widget.activity.attendeeIds?.length.toString() ?? '0', color: Colors.black,),
                          ],
                        ),
                       /* Row(
                          children: [
                            CustomPeerPALHeading3(
                              text: "DEBUG Activity ID: ",
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(width: 10),
                            Container(width: 100, child: Flexible(child: CustomPeerPALHeading3(text: widget.activity.id!, color: Colors.red,))),
                          ],
                        ),*/
                      ],
                    ),
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
                            text:widget.activity.description ?? '', color: Colors.black),
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
