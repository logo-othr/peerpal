import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activities/activity_feed/activity_feed_content.dart';
import 'package:peerpal/activities/activity_feed/bloc/activity_feed_bloc.dart';


class ActivityFeedPage extends StatelessWidget {

  const ActivityFeedPage({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider<ActivityFeedBloc>(
        create: (context) => ActivityFeedBloc(
        )..add(LoadActivityFeed()),
        child: ActivityFeedContent(),
      ),
    );
  }
}
