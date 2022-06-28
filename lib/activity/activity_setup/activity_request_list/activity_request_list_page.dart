import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activity/activity_setup/activity_request_list/activity_request_list_content.dart';
import 'package:peerpal/activity/activity_setup/activity_request_list/bloc/activity_request_list_bloc.dart';
import 'package:peerpal/injection.dart';

class ActivityRequestListPage extends StatelessWidget {
  const ActivityRequestListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider<ActivityRequestListBloc>(
        child: ActivityRequestListContent(),
        create: (context) =>
            sl<ActivityRequestListBloc>()..add(LoadActivityRequestList()),
      ),
    );
  }
}
