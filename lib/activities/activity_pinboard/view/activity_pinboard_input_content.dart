import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_cupertino_search_bar.dart';
import 'package:peerpal/widgets/custom_empty_list_hint.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';

import '../../../colors.dart';

class PinboardInputContent extends StatelessWidget {

  final bool isInFlowContext;

  PinboardInputContent({Key? key, required this.isInFlowContext}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var searchFieldController = TextEditingController();
    searchFieldController.text = "Derzeit noch deaktiviert";
    return Scaffold(
      appBar: CustomAppBar("Öffentliche Aktivitäten", hasBackButton: false,),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(width: 1, color: secondaryColor),
                        bottom: BorderSide(width: 1, color: secondaryColor))),
                child: CustomCupertinoSearchBar(heading: '', enabled: false, searchBarController: searchFieldController,)),
            Spacer(),
            CustomEmptyListHint(icon: Icons.nature_people, text: "Es wurden noch keine öffentliche \nAktivität geplant"),
            Spacer(),
            Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    CustomPeerPALButton(
                      text: "Aktivität planen",
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}