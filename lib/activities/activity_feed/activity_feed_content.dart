import 'package:flutter/material.dart';
import 'package:peerpal/activities/activity_wizard_flow.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/widgets/custom_cupertino_search_bar.dart';
import 'package:peerpal/widgets/custom_empty_list_hint.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';

class ActivityFeedContent extends StatelessWidget {
  const ActivityFeedContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: CustomCupertinoSearchBar()),
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
                      onPressed: () =>             ActivityWizardFlow.route(Activity()),
                        ,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

