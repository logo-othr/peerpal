import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activities/activity_joined_list/activity_joined_list_content.dart';
import 'package:peerpal/activities/activity_joined_list/bloc/activity_joined_list_bloc.dart';
import 'package:peerpal/injection.dart';

class ActivityJoinedListPage extends StatelessWidget {
  const ActivityJoinedListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider<ActivityJoinedListBloc>(
        child: ActivityJoinedListContent(),
        create: (context) =>
            sl<ActivityJoinedListBloc>()..add(LoadActivityJoinedList()),
      ),
    );
  }
}
