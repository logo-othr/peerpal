import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activity/data/repository/activity_repository.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/presentation/activity_feed/bloc/activity_feed_bloc.dart';
import 'package:peerpal/activity/presentation/activity_requests/activity_request_list_page.dart';
import 'package:peerpal/activity/presentation/activity_setup/activity_overview_page/view/activity_overview_input_page.dart';
import 'package:peerpal/activity/presentation/activity_setup/activity_public_overview_page/view/activity_public_overview_page.dart';
import 'package:peerpal/activity/presentation/activity_setup/activity_wizard_flow.dart';
import 'package:peerpal/activity/presentation/joined_activities/activity_joined_list_page.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/data/resources/colors.dart';
import 'package:peerpal/data/resources/strings.dart';
import 'package:peerpal/peerpal_user/domain/usecase/get_user_usecase.dart';
import 'package:peerpal/setup.dart';
import 'package:peerpal/widgets/custom_activity_card.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_invitation_button.dart';
import 'package:uuid/uuid.dart';

class ActivityFeedContent extends StatefulWidget {
  const ActivityFeedContent({Key? key}) : super(key: key);

  @override
  State<ActivityFeedContent> createState() => _ActivityFeedContentState();
}

class _ActivityFeedContentState extends State<ActivityFeedContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityFeedBloc, ActivityFeedState>(
        builder: (context, state) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // ToDo: Move into cubit/bloc
            GetAuthenticatedUser _getAuthenticatedUser =
                sl<GetAuthenticatedUser>();
            var currentUserName = (await _getAuthenticatedUser()).name;
            Activity activity = Activity(
              id: (Uuid()).v4().toString(),
              creatorId:
                  context.read<AuthenticationRepository>().currentUser.id,
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
    searchFieldController.text = Strings.searchDisabled;

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Column(
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
                      badgeColor: Colors.green,
                      small: true,
                      length: snapshot.data!.length.toString()),
                );
              }
            },
          ),
/*          Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(width: 1, color: secondaryColor),
                      bottom: BorderSide(width: 1, color: secondaryColor))),
              child: CustomCupertinoSearchBar(
                enabled: false,
                  searchBarController: searchFieldController)),*/

          Container(
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6,
              border:
                  Border(bottom: BorderSide(width: 1, color: secondaryColor)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 0.3,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child:
            TabBar(indicatorWeight: 3, indicatorColor: primaryColor, tabs: [
              Tab(
                  child: Center(
                child: Text(
                  "ÖFFENTLICHE AKTIVITÄTEN",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: MediaQuery.of(context).size.width / 35),
                ),
              )),
              Tab(
                  child: Center(
                child: Text(
                  "ERSTELLTE AKTIVTÄTEN",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: MediaQuery.of(context).size.width / 35),
                ),
              )),
            ]),
          ),
          Expanded(
            child: TabBarView(children: [
              //TAB ÖFFENTLICHE AKTIVITÄTEN
              Column(
                children: [
                  /*       Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            //top: BorderSide(width: 1, color: secondaryColor),
                              bottom: BorderSide(width: 1, color: secondaryColor))),
                      child: CustomCupertinoSearchBar(
                          enabled: false,
                          searchBarController: searchFieldController)),*/
                  Expanded(
                    child: StreamBuilder<List<Activity>>(
                      stream: context
                          .read<ActivityFeedBloc>()
                          .state
                          .publicActivityStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Activity>> snapshot) {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                                "Es gibt noch keine öffentlichen Aktivitäten."),
                          );
                        } else {
                          return Scrollbar(
                            child: ListView.builder(
                              itemBuilder: (context, index) =>
                                  buildActivityFeedCard(
                                      context,
                                      snapshot.data![index],
                                      context
                                          .read<ActivityFeedBloc>()
                                          .isOwnCreatedActivity(
                                              snapshot.data![index])),
                              itemCount: snapshot.data!.length,
                              controller: ScrollController(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),

              //TAB EIGENE AKTIVITÄTEN
              Column(
                children: [
                  /*   Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            //top: BorderSide(width: 1, color: secondaryColor),
                              bottom: BorderSide(width: 1, color: secondaryColor))),
                      child: CustomCupertinoSearchBar(
                          enabled: false,
                          searchBarController: searchFieldController)),*/
                  Expanded(
                    child: StreamBuilder<List<Activity>>(
                      stream: context
                          .read<ActivityFeedBloc>()
                          .state
                          .createdActivityStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Activity>> snapshot) {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child:
                                Text("Du hast noch keine Aktivität erstellt."),
                          );
                        } else {
                          return Scrollbar(
                            child: ListView.builder(
                              itemBuilder: (context, index) =>
                                  buildActivityFeedCard(
                                      context,
                                      snapshot.data![index],
                                      context
                                          .read<ActivityFeedBloc>()
                                          .isOwnCreatedActivity(
                                              snapshot.data![index])),
                              itemCount: snapshot.data!.length,
                              controller: ScrollController(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ]),
          ),

          /* Expanded(
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
          ),*/
        ],
      ),
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
