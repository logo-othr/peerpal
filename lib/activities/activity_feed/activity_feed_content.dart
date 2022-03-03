import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activities/activity_feed/bloc/activity_feed_bloc.dart';
import 'package:peerpal/activities/activity_joined_list/activity_joined_list_page.dart';
import 'package:peerpal/activities/activity_public_overview_page/view/activity_public_overview_page.dart';
import 'package:peerpal/activities/activity_overview_page/view/activity_overview_input_page.dart';
import 'package:peerpal/activities/activity_request_list/activity_request_list_page.dart';
import 'package:peerpal/activities/activity_wizard_flow.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/injection.dart';
import 'package:peerpal/repository/activity_repository.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_cupertino_search_bar.dart';
import 'package:peerpal/widgets/custom_empty_list_hint.dart';
import 'package:peerpal/widgets/custom_invitation_button.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_activity_card.dart';
import 'package:uuid/uuid.dart';

class ActivityFeedContent extends StatefulWidget {
  const ActivityFeedContent({Key? key}) : super(key: key);

  @override
  State<ActivityFeedContent> createState() => _ActivityFeedContentState();
}

class _ActivityFeedContentState extends State<ActivityFeedContent> {
  final ScrollController listScrollController = ScrollController();

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityFeedBloc, ActivityFeedState>(
        builder: (context, state) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var currentUserName = (await context
                    .read<AppUserRepository>()
                    .getCurrentUserInformation())
                .name;
            Activity activity = Activity(
              id: (Uuid()).v4().toString(),
              creatorId: context.read<AppUserRepository>().currentUser.id,
              creatorName: currentUserName,
              public: false,
            );
            context.read<ActivityRepository>().updateLocalActivity(activity);
            await Navigator.of(context).push(ActivityWizardFlow.route(
                activity)); // ToDo: Move to domain layer
          },
          backgroundColor: primaryColor,
          child: Icon(Icons.add),
        ),
        appBar: CustomAppBar(
          'Aktivitäten',
          hasBackButton: false,
        ),
        body: BlocBuilder<ActivityFeedBloc, ActivityFeedState>(
            builder: (context, state) {
          if (state.status == ActivityFeedStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == ActivityFeedStatus.success) {
            return ActivityFeedList(context);
          } else {
            return ActivityFeedList(context);
          }
        }),
      );
    });
  }

  Widget ActivityFeedList(BuildContext context) {
    var searchFieldController = TextEditingController();
    searchFieldController.text = "Derzeit noch deaktiviert";

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        StreamBuilder<List<Activity>>(
          stream: context.read<ActivityFeedBloc>().state.activityRequestList,
          builder:
              (BuildContext context, AsyncSnapshot<List<Activity>> snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container();
            } else {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActivityRequestListPage()));
                },
                child: CustomInvitationButton(
                    text: "Aktivitätseinladungen",
                    icon: Icons.email,
                    small: true,
                    length: snapshot.data!.length.toString()),
              );
            }
          },
        ),
        StreamBuilder<List<Activity>>(
          stream: context.read<ActivityFeedBloc>().state.activityJoinedList,
          builder:
              (BuildContext context, AsyncSnapshot<List<Activity>> snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container();
            } else {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActivityJoinedListPage()));
                },
                child: CustomInvitationButton(
                    text: "Beigetretene Aktivitäten",
                    icon: Icons.nature_people_rounded,
                    header: 'Öffentliche Aktivitäten',
                    small: true,
                    length: snapshot.data!.length.toString()),
              );
            }
          },
        ),
        Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(width: 1, color: secondaryColor),
                    bottom: BorderSide(width: 1, color: secondaryColor))),
            child: CustomCupertinoSearchBar(
                searchBarController: searchFieldController)),
        Expanded(
          child: StreamBuilder<List<Activity>>(
            stream: context.read<ActivityFeedBloc>().state.activityStream,
            builder:
                (BuildContext context, AsyncSnapshot<List<Activity>> snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text("Es gibt noch keine öffentlichen Aktivitäten."),
                );
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) => buildActivityFeedCard(
                      context,
                      snapshot.data![index],
                      context
                          .read<ActivityFeedBloc>()
                          .isOwnCreatedActivity(snapshot.data![index])),
                  itemCount: snapshot.data!.length,
                  controller: listScrollController,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildActivityFeedCard(
      BuildContext context, Activity activity, bool isOwnCreatedActivity) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: secondaryColor))),
      child: isOwnCreatedActivity
          ? TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OverviewInputPage(
                          isInFlowContext: false,
                          activity: activity,
                        )));
              },
              child: CustomActivityCard(
                activity: activity,
                isOwnCreatedActivity: isOwnCreatedActivity,
              ),
            )
          : TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ActivityPublicOverviewPage(activity: activity)),
                );
              },
              child: CustomActivityCard(
                activity: activity,
                isOwnCreatedActivity: isOwnCreatedActivity,
              ),
            ),
    );
  }
}
