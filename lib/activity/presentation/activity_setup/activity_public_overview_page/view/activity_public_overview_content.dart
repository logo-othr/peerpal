import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:peerpal/activity/data/resources/activity_icon_data..dart';
import 'package:peerpal/activity/presentation/activity_setup/activity_public_overview_page/cubit/activity_public_overview_cubit.dart';
import 'package:peerpal/chat/presentation/user_detail_page/user_detail_page.dart';
import 'package:peerpal/data/resources/colors.dart';
import 'package:peerpal/widgets/custom_activity_participations_dialog.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/custom_single_creator_table_view.dart';
import 'package:peerpal/widgets/custom_single_description_table_view.dart';
import 'package:peerpal/widgets/custom_single_location_table_view.dart';
import 'package:peerpal/widgets/custom_single_participants_table_view.dart';
import 'package:peerpal/widgets/custom_single_table.dart';

class ActivityPublicOverviewContent extends StatefulWidget {
  ActivityPublicOverviewContent({Key? key}) : super(key: key);

  @override
  State<ActivityPublicOverviewContent> createState() =>
      _ActivityPublicOverviewContentState();
}

class _ActivityPublicOverviewContentState
    extends State<ActivityPublicOverviewContent> {
  final TextEditingController descriptionController = TextEditingController();

  void showAttendeeDialog(activityAttendeesList) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomActivityParticipationsDialog(
              isOwnCreatedActivity: false,
              isAttendeeDialog: true,
              userNames: activityAttendeesList);
        });
  }

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
              List<String>? activityAttendeesList =
                  activityAttendees.map((e) => e.name!).toList();
              activityAttendeesList.sort();

              if (activity.description != null)
                descriptionController.text = activity.description!;
              String location = "";
              if (activity.location!.streetNumber == null)
                location = "${activity.location!.street}";
              else
                location =
                    "${activity.location!.street} ${activity.location!.streetNumber}";

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              bottom: BorderSide(
                                  width: 1,
                                  color: PeerPALAppColor.secondaryColor))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          AvatarUI(
                            avatarIcon:
                                ActivityIconData.icons[state.activity.code]!,
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
                        child: Scrollbar(
                          isAlwaysShown: true,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                CustomSingleCreatorTable(
                                    heading: "ERSTELLER",
                                    text: activity.creatorName,
                                    avatar: (activityCreator.imagePath ==
                                                null ||
                                            activityCreator.imagePath!.isEmpty)
                                        ? Icon(
                                            Icons.account_circle,
                                            size: 40.0,
                                            color: Colors.grey,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl:
                                                activityCreator.imagePath!,
                                            errorWidget:
                                                (context, object, stackTrace) {
                                              return const Icon(
                                                Icons.account_circle,
                                                size: 40.0,
                                                color: Colors.grey,
                                              );
                                            },
                                          ),
                                    tapIcon: Icons.email,
                                    isOwnCreatedActivity: false,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UserDetailPage(
                                                      activity.creatorId!)));
                                    }),
                                CustomSingleTable(
                                  heading: "DATUM",
                                  text: DateFormat('dd.MM.yyyy').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          activity.date!)),
                                  isArrowIconVisible: false,
                                ),
                                CustomSingleTable(
                                  heading: "UHRZEIT",
                                  text:
                                      '${DateFormat('kk:mm').format(DateTime.fromMillisecondsSinceEpoch(activity.date!))} Uhr',
                                  isArrowIconVisible: false,
                                ),
                                CustomSingleLocationTable(
                                    heading: "ORT",
                                    text: activity.location!.place,
                                    subText: location,
                                    isArrowIconVisible: false),
                                CustomSingleParticipantsTable(
                                    onPressed: () => {
                                          showAttendeeDialog(
                                              activityAttendeesList)
                                        },
                                    heading: "TEILNEHMER",
                                    text: activityAttendees
                                        .map((e) => e.name)
                                        .toList()
                                        .join(", "),
                                    isArrowIconVisible: true),
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

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      new SnackBar(
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      new SnackBar(
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

class AvatarUI extends StatelessWidget {
  final IconData avatarIcon;

  const AvatarUI({Key? key, required this.avatarIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
      child: Container(
          child: CircleAvatar(
            radius: 35,
            child: Icon(
              avatarIcon,
              size: 50,
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
    );
  }
}