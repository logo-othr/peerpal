import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/presentation/activity_requests/bloc/activity_request_list_bloc.dart';
import 'package:peerpal/activity/presentation/activity_setup/activity_public_overview_page/view/activity_public_overview_page.dart';
import 'package:peerpal/data/resources/colors.dart';
import 'package:peerpal/data/resources/strings.dart';
import 'package:peerpal/widgets/custom_activity_card.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';

class ActivityRequestListContent extends StatefulWidget {
  const ActivityRequestListContent({Key? key}) : super(key: key);

  @override
  State<ActivityRequestListContent> createState() =>
      _ActivityRequestListContentState();
}

class _ActivityRequestListContentState
    extends State<ActivityRequestListContent> {
  final ScrollController listScrollController = ScrollController();

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityRequestListBloc, ActivityRequestListState>(
        builder: (context, state) {
      return Scaffold(
        appBar: CustomAppBar(
          'Aktivitäten',
          hasBackButton: true,
        ),
        body: BlocBuilder<ActivityRequestListBloc, ActivityRequestListState>(
            builder: (context, state) {
          if (state.status == ActivityRequestListStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == ActivityRequestListStatus.success) {
            return ActivityRequestList(context);
          } else {
            return ActivityRequestList(context);
          }
        }),
      );
    });
  }

  Widget ActivityRequestList(BuildContext context) {
    var searchFieldController = TextEditingController();
    searchFieldController.text = Strings.searchDisabled;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
/*        Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(width: 1, color: secondaryColor),
                    bottom: BorderSide(width: 1, color: secondaryColor))),
            child: CustomCupertinoSearchBar(
                searchBarController: searchFieldController)),*/
        Expanded(
          child: StreamBuilder<List<Activity>>(
            stream: context
                .read<ActivityRequestListBloc>()
                .state
                .activityRequestList,
            builder:
                (BuildContext context, AsyncSnapshot<List<Activity>> snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text("Es existieren noch keine Einladungen."),
                );
              } else {
                return Scrollbar(
                  child: ListView.builder(
                    itemBuilder: (context, index) =>
                        buildActivityRequestListCard(
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

  Widget buildActivityRequestListCard(BuildContext context, Activity activity) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: secondaryColor))),
      child: TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ActivityPublicOverviewPage(activity: activity)));
        },
        child:
            CustomActivityCard(activity: activity, isOwnCreatedActivity: false),
      ),
    );
  }
}
