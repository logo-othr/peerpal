import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:peerpal/activities/activity_public_overview_page/cubit/activity_public_overview_cubit.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/repository/activity_icon_data..dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/widgets/custom_activity_overview_header_card.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/custom_single_location_table_view.dart';
import 'package:peerpal/widgets/custom_single_creator_table_view.dart';
import 'package:peerpal/widgets/custom_single_description_table_view.dart';
import 'package:peerpal/widgets/custom_single_participants_table_view.dart';
import 'package:peerpal/widgets/custom_single_table.dart';

class ActivityPublicOverviewContent extends StatelessWidget {
  final TextEditingController descriptionController = TextEditingController();

  ActivityPublicOverviewContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        "Aktivität",
        hasBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
        child: BlocBuilder<ActivityPublicOverviewCubit,
            ActivityPublicOverviewState>(
          builder: (context, state) {
            if (state is ActivityPublicOverviewLoaded) {
              var activity = state.activity;
              var activityCreator = state.activityCreator;
              var activityAttendees = state.attendees;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: secondaryColor))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                            child: Container(
                                child: CircleAvatar(
                                  radius: 35,
                                  child: Icon(
                                    ActivityIconData
                                        .icons[state.activity.code]!,
                                    size: 50,
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
                          CustomPeerPALHeading3(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              text: activity.name!),
                        ],
                      )),
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
                                  avatar:
                                      NetworkImage(activityCreator.imagePath!),
                                  tapIcon: Icons.email),
                              CustomSingleTable(
                                heading: "DATUM",
                                text: DateFormat('dd.MM.yyyy')
                                    .format(activity.date!),
                                isArrowIconVisible: false,
                              ),
                              CustomSingleTable(
                                heading: "UHRZEIT",
                                text:
                                    '${DateFormat('kk:mm').format(activity.date!)} Uhr',
                                isArrowIconVisible: false,
                              ),
                              CustomSingleLocationTable(
                                  heading: "ORT",
                                  text: activity.location!.place,
                                  subText:
                                      "${activity.location!.street} ${activity.location!.streetNumber}",
                                  isArrowIconVisible: false),
                              CustomSingleParticipantsTable(
                                  heading: "TEILNEHMER",
                                  text: activityAttendees
                                      .map((e) => e.name)
                                      .toList()
                                      .join(", "),
                                  isOwnCreatedActivity: false,
                                  userNames: activityAttendees
                                      .map((e) => e.name)
                                      .toList(),
                                  isArrowIconVisible: false),
                              CustomSingleDescriptionTable(
                                heading: "BESCHREIBUNG",
                                isEditingModus: false,
                                textEditingController: descriptionController,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  state.isAttendee
                      ? Container(
                          color: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              CustomPeerPALButton(
                                onPressed: () {
                                 context
                                      .read<ActivityPublicOverviewCubit>()
                                      .leaveActivity();

                                  Scaffold.of(context).showSnackBar(new SnackBar(
                                      content: new Text(
                                          "Du hast die Aktivität verlassen.")));
                                },
                                text: "Aktivität verlassen",
                                color: Colors.red,
                              ),
                            ],
                          ))
                      : Container(
                          color: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              CustomPeerPALButton(
                                onPressed: () {
                                  context
                                      .read<ActivityPublicOverviewCubit>()
                                      .joinActivity();
                                  Scaffold.of(context).showSnackBar(new SnackBar(
                                      content: new Text(
                                          "Du bist der Aktivität beigetreten.")));
                                },
                                text: "Aktivität beitreten",
                              ),
                            ],
                          )),
                ],
              );
            } else
              return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
