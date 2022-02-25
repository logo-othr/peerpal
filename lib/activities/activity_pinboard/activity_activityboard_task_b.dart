import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_cupertino_search_bar.dart';
import 'package:peerpal/widgets/custom_invitation_button.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_pinnwand_card.dart';

import '../../colors.dart';



class ActivityActivityboardTaskB extends StatefulWidget {
  @override
  _ActivityActivityboardTaskBState createState() => _ActivityActivityboardTaskBState();
}

class _ActivityActivityboardTaskBState extends State<ActivityActivityboardTaskB> {
  @override
  Widget build(BuildContext context) {
    var searchFieldController = TextEditingController();
    searchFieldController.text = "Derzeit noch deaktiviert";
    return Scaffold(
      appBar: CustomAppBar("Öffentliche Aktivitäten", hasBackButton: null,),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CustomInvitationButton(length: "0", text: "Aktivitäteneinladungen", icon: Icons.mail, header: "Pinnwand",),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          top: BorderSide(width: 1, color: secondaryColor),
                          bottom: BorderSide(width: 1, color: secondaryColor))),
                  child: CustomCupertinoSearchBar(heading: '', enabled: false, searchBarController: searchFieldController,)),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        CustomPinnwandCard(isOwnCreatedActivity: true, name: '',),
                        SizedBox(width: 30),
                        CustomPinnwandCard(isOwnCreatedActivity: false, name: '',),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,10,0,0),
                child: CustomPeerPALButton(
                  text: "Aktivität planen",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
