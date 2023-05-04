import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/presentation/activity_setup/activity_public_overview_page/view/activity_public_overview_page.dart';
import 'package:peerpal/activity/presentation/joined_activities/bloc/activity_joined_list_bloc.dart';
import 'package:peerpal/app/data/resources/colors.dart';
import 'package:peerpal/app/data/resources/strings.dart';
import 'package:peerpal/widgets/custom_activity_card.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';

class ActivityJoinedListContent extends StatefulWidget {
  const ActivityJoinedListContent({Key? key}) : super(key: key);

  @override
  State<ActivityJoinedListContent> createState() =>
      _ActivityJoinedListContentState();
}

class _ActivityJoinedListContentState extends State<ActivityJoinedListContent> {
  final ScrollController listScrollController = ScrollController();

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityJoinedListBloc, ActivityJoinedListState>(
        builder: (context, state) {
      return Scaffold(
        appBar: CustomAppBar(
          'Aktivitäten',
          hasBackButton: true,
        ),
        body: BlocBuilder<ActivityJoinedListBloc, ActivityJoinedListState>(
            builder: (context, state) {
          if (state.status == ActivityJoinedListStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == ActivityJoinedListStatus.success) {
            return ActivityJoinedList(context);
          } else {
            return ActivityJoinedList(context);
          }
        }),
      );
    });
  }

  Widget ActivityJoinedList(BuildContext context) {
    var searchFieldController = TextEditingController();
    searchFieldController.text = Strings.searchDisabled;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        /* Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(width: 1, color: PeerPALAppColor.secondaryColor),
                    bottom: BorderSide(width: 1, color: PeerPALAppColor.secondaryColor))),
            child: CustomCupertinoSearchBar(
                searchBarController: searchFieldController)),*/
        Expanded(
          child: StreamBuilder<List<Activity>>(
            stream:
                context.read<ActivityJoinedListBloc>().state.activityJoinedList,
            builder:
                (BuildContext context, AsyncSnapshot<List<Activity>> snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text("Bu bist noch keiner Aktivität beigetreten."),
                );
              } else {
                return Scrollbar(
                  child: ListView.builder(
                    itemBuilder: (context, index) =>
                        buildActivityJoinedListCard(
                            context, snapshot.data![index]),
                    itemCount: snapshot.data!.length,
                    controller: listScrollController,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildActivityJoinedListCard(BuildContext context, Activity activity) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom:
                  BorderSide(width: 1, color: PeerPALAppColor.secondaryColor))),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ActivityPublicOverviewPage(activity: activity)),
          );
        },
        child:
            CustomActivityCard(activity: activity, isOwnCreatedActivity: false),
      ),
    );
  }
}
