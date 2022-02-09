import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:peerpal/activities/activity_overview_page/cubit/activity_overview_cubit.dart';
import 'package:peerpal/repository/activity_icon_data..dart';
import 'package:peerpal/widgets/custom_activity_overview_header_card.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_activity_header_card.dart';
import 'package:peerpal/widgets/custom_singel_location_table_view.dart';
import 'package:peerpal/widgets/custom_single_creator_table_view.dart';
import 'package:peerpal/widgets/custom_single_description_table_view.dart';
import 'package:peerpal/widgets/custom_single_participants_table_view.dart';
import 'package:peerpal/widgets/custom_single_table.dart';

class OverviewInputContent extends StatelessWidget {
  final bool isInFlowContext;

  OverviewInputContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        "Aktivität",
        hasBackButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
        child: BlocBuilder<OverviewInputCubit, ActivityOverviewState>(
          builder: (context, state) {
            if(state is ActivityOverviewLoaded) {
              var activity = state.activity;
              var activityCreator = state.activityCreator;
              var activityAttendees = state.attendees;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomActivityOverviewHeaderCard(ActivityIconData.icons[state.activity.code]!, activity.name!),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                      child: Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              CustomSingleCreatorTable(
                                  heading: "ERSTELLER",
                                  text: activity.creatorName,
                                  avatar: NetworkImage(activityCreator.imagePath!),
                                  tapIcon: Icons.email),
                              CustomSingleTable(
                                heading: "DATUM",
                                text: DateFormat('dd.MM.yyyy').format(activity.date!),
                                isArrowIconVisible: true,
                                onPressed: () {},
                              ),
                              CustomSingleTable(
                                heading: "UHRZEIT",
                                text: DateFormat('kk:mm').format(activity.date!),
                                isArrowIconVisible: true,
                                onPressed: () {},
                              ),
                              CustomSingleLocationTable(
                                  heading: "ORT",
                                  text: activity.location!.place,
                                  subText: "${activity.location!.street} ${activity.location!.streetNumber}"),
                              CustomSingleParticipantsTable(
                                heading: "TEILNEHMER",
                                text: activityAttendees.map((e) => e.name).toList().join(", "),
                                isOwnCreatedActivity: true,
                              ),
                              CustomSingleDescriptionTable(
                                heading: "BESCHREIBUNG",
                                isEditingModus: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          CustomPeerPALButton(
                            text: "Aktivität erstellen",
                          ),
                        ],
                      ))
                ],
              );
            } else return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
