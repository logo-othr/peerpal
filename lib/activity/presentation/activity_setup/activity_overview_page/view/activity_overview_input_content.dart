import 'package:cached_network_image/cached_network_image.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/presentation/activity_setup/activity_date/view/activity_date_input_page.dart';
import 'package:peerpal/activity/presentation/activity_setup/activity_invitation/view/activity_invitation_input_page.dart';
import 'package:peerpal/activity/presentation/activity_setup/activity_location/view/activity_location_input_page.dart';
import 'package:peerpal/activity/presentation/activity_setup/activity_overview_page/cubit/activity_overview_cubit.dart';
import 'package:peerpal/data/activity_icon_data..dart';
import 'package:peerpal/widgets/custom_activity_overview_header_card.dart';
import 'package:peerpal/widgets/custom_activity_participations_dialog.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_dialog.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_single_creator_table_view.dart';
import 'package:peerpal/widgets/custom_single_description_table_view.dart';
import 'package:peerpal/widgets/custom_single_location_table_view.dart';
import 'package:peerpal/widgets/custom_single_participants_table_view.dart';
import 'package:peerpal/widgets/custom_single_table.dart';

class OverviewInputContent extends StatefulWidget {
  final bool isInFlowContext;

  OverviewInputContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  @override
  State<OverviewInputContent> createState() => _OverviewInputContentState();
}

class _OverviewInputContentState extends State<OverviewInputContent> {
  final TextEditingController descriptionController = TextEditingController();

  void onDeleteButtonPressed() async {
    context.read<OverviewInputCubit>().deleteActivity();
    Navigator.pop(context);
  }

  void onCancelButtonPressed() async {
    context.flow<Activity>().complete();
    Navigator.pop(context);
  }

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

  deleteActivity() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
              dialogHeight: 250,
              actionButtonText: 'Löschen',
              dialogText: "Möchten Sie diese Aktivität wirklich löschen?",
              onPressed: onDeleteButtonPressed);
        });
  }

  cancelActivity() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
              dialogHeight: 250,
              actionButtonText: 'Die Aktivität verwerfen',
              dialogText: "Möchten Sie diese Aktivität wirklich verwerfen?",
              onPressed: onCancelButtonPressed);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        "Aktivität",
        hasBackButton: false,
        actionButtonWidget: !widget.isInFlowContext
            ? Center(
                child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Text('Löschen', style: TextStyle(fontSize: 16)),
              ))
            : Center(
                child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Text('Verwerfen', style: TextStyle(fontSize: 16)),
              )),
        onActionButtonPressed: !widget.isInFlowContext
            ? () {
                deleteActivity();
              }
            : () {
                cancelActivity();
              },
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
        child: BlocBuilder<OverviewInputCubit, ActivityOverviewState>(
          builder: (context, state) {
            if (state is ActivityOverviewLoaded) {
              Activity activity = state.activity;
              var activityCreator = state.activityCreator;
              var activityAttendees = state.attendees;
              List<String>? activityAttendeesList =
                  activityAttendees.map((e) => e.name!).toList();
              activityAttendeesList.sort();
              var activityInvitedFriends = state.invitationIds;
              var cubit = context.read<OverviewInputCubit>();
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
                  CustomActivityOverviewHeaderCard(
                    icon: ActivityIconData.icons[state.activity.code]!,
                    heading: activity.name!,
                    isActive: (state.activity.public ?? false),
                    onActive: () {
                      cubit.setActivityToPublic();
                    },
                    onInactive: () {
                      cubit.setActivityToPrivate();
                    },
                  ),
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
                                    isOwnCreatedActivity: true),
                                CustomSingleTable(
                                  onPressed: () async => {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ActivitySelectDatePage(
                                                isInFlowContext: false,
                                              )),
                                    ).then((value) =>
                                        context.read<OverviewInputCubit>()
                                          ..loadData())
                                  },
                                  heading: "DATUM",
                                  text: DateFormat('dd.MM.yyyy').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          activity.date!)),
                                  isArrowIconVisible: true,
                                ),
                                CustomSingleTable(
                                  onPressed: () async => {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ActivitySelectDatePage(
                                                isInFlowContext: false,
                                              )),
                                    ).then((value) =>
                                        context.read<OverviewInputCubit>()
                                          ..loadData())
                                  },
                                  heading: "UHRZEIT",
                                  text: DateFormat('kk:mm').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          activity.date!)),
                                  isArrowIconVisible: true,
                                ),
                                CustomSingleLocationTable(
                                    onPressed: () async => {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LocationInputPage(
                                                      isInFlowContext: false,
                                                    )),
                                          ).then((value) =>
                                              context.read<OverviewInputCubit>()
                                                ..loadData())
                                        },
                                    heading: "ORT",
                                    text: activity.location!.place,
                                    subText: location,
                                    isArrowIconVisible: true),
                                CustomSingleParticipantsTable(
                                  onPressed: () async => {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              InvitationInputPage(
                                                isInFlowContext: false,
                                              )),
                                    ).then((value) =>
                                        context.read<OverviewInputCubit>()
                                          ..loadData())
                                  },
                                  heading: "EINGELADEN",
                                  text: activityInvitedFriends
                                      .map((e) => e.name)
                                      .toList()
                                      .join(", "),
                                  isArrowIconVisible: true,
                                ),
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
                                  isEditingModus: true,
                                  textEditingController: descriptionController,
                                ),
                              ],
                            ),
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
                          widget.isInFlowContext
                              ? CustomPeerPALButton(
                                  onPressed: () async {
                                    await context
                                        .read<OverviewInputCubit>()
                                        .createActivity(
                                            descriptionController.text,
                                            DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString());
                                    context.flow<Activity>().complete();
                                    Navigator.pop(context);
                                  },
                                  text: "Aktivität erstellen",
                                )
                              : CustomPeerPALButton(
                                  onPressed: () async {
                                    await context
                                        .read<OverviewInputCubit>()
                                        .updateActivity(
                                            descriptionController.text,
                                            DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString());
                                    Navigator.pop(context);
                                  },
                                  text: "Aktivität speichern",
                                )
                        ],
                      ))
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
