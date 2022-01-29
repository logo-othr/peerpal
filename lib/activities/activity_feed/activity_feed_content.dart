import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activities/activity_feed/bloc/activity_feed_bloc.dart';
import 'package:peerpal/activities/activity_wizard_flow.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/widgets/custom_cupertino_search_bar.dart';
import 'package:peerpal/widgets/custom_empty_list_hint.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:uuid/uuid.dart';

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
            CustomEmptyListHint(
                icon: Icons.nature_people,
                text: "Es wurden noch keine öffentliche \nAktivität geplant"),
            Spacer(),
            Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    BlocBuilder<ActivityFeedBloc, ActivityFeedState>(
                      builder: (context, state) {
                        return CustomPeerPALButton(
                            text: "Aktivität planen",
                            onPressed: () async {
                              var currentUserName = (await context
                                      .read<AppUserRepository>()
                                      .getCurrentUserInformation())
                                  .name;
                              await Navigator.of(context)
                                  .push(ActivityWizardFlow.route(Activity(
                                id: (Uuid()).v4().toString(),
                                creatorId: context
                                    .read<AppUserRepository>()
                                    .currentUser
                                    .id,
                                creatorName: currentUserName,
                              ))); // ToDo: Move to domain layer
                            });
                      },
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
