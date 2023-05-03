import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peerpal/activity/data/resources/activity_icon_data.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

import '../data/resources/colors.dart';

// ignore: must_be_immutable
class CustomActivityCard extends StatefulWidget {
  Activity activity;
  bool isOwnCreatedActivity = false;

  CustomActivityCard(
      {required this.activity, required this.isOwnCreatedActivity});

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
                    ? PeerPALAppColor.primaryColor
                    : PeerPALAppColor.secondaryColor),
            boxShadow: [
              BoxShadow(
                color: PeerPALAppColor.secondaryColor,
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
                                    ? PeerPALAppColor.primaryColor
                                    : PeerPALAppColor.secondaryColor))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          flex: 30,
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
                                    color: PeerPALAppColor.primaryColor,
                                    width: 2.0,
                                  ),
                                )),
                          ),
                        ),
                        Flexible(
                          flex: 50,
                          child: Text(
                            widget.activity.name!,
                            style: TextStyle(
                              color: PeerPALAppColor.primaryColor,
                              fontSize: MediaQuery.of(context).size.width / 20,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        Flexible(
                            flex: 20,
                            child: widget.isOwnCreatedActivity
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                    child: Icon(
                                      Icons.edit,
                                      color: PeerPALAppColor.primaryColor,
                                      size: 30,
                                    ),
                                  )
                                : Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                    child: Container(width: 30),
                                  ))
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
                                  ? PeerPALAppColor.primaryColor
                                  : PeerPALAppColor.secondaryColor))),
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
                                text: "Ersteller: "),
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
                        _ActivityDescription(
                            headlineText: "Datum: ",
                            length: (DateFormat('dd.MM.yyyy kk:mm').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    widget.activity.date!)))),
                        SizedBox(height: 5),
                        _ActivityDescription(
                            headlineText: "Ort: ",
                            length: widget.activity.location?.place),
                        SizedBox(height: 5),
                        _ActivityDescription(
                          headlineText: "Teilnehmer",
                          length:
                              widget.activity.attendeeIds?.length.toString(),
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
                              ? CustomPeerPALHeading3(
                            text: 'Beschreibung ausblenden',
                                  color: PeerPALAppColor.primaryColor,
                                  fontWeight: FontWeight.bold,
                                )
                              : CustomPeerPALHeading3(
                            text: 'Beschreibung anzeigen',
                                  color: PeerPALAppColor.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ));
                    },
                    body: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                        child: CustomPeerPALHeading3(
                            text: widget.activity.description ?? '',
                            color: Colors.black),
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

class _ActivityDescription extends StatelessWidget {
  const _ActivityDescription({
    Key? key,
    required this.headlineText,
    required this.length,
  }) : super(key: key);

  final String headlineText;
  final String? length;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomPeerPALHeading3(
          text: headlineText,
          fontWeight: FontWeight.bold,
        ),
        CustomPeerPALHeading3(
          text: length ?? '0',
          color: Colors.black,
        ),
      ],
    );
  }
}
