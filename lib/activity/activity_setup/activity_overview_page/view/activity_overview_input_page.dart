import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activity/activity_setup/activity_overview_page/cubit/activity_overview_cubit.dart';
import 'package:peerpal/activity/data/repository/activity_repository.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/activity.dart';

import 'activity_overview_input_content.dart';

class OverviewInputPage extends StatelessWidget {
  final bool isInFlowContext;
  final Activity? activity;

  OverviewInputPage({required this.isInFlowContext, this.activity});

  static MaterialPage<void> page(
      {required bool isInFlowContext, Activity? activity}) {
    return MaterialPage<void>(
        child: OverviewInputPage(
            isInFlowContext: isInFlowContext, activity: activity));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: BlocProvider(
        create: (_) {
          return OverviewInputCubit(context.read<ActivityRepository>(),
              context.read<AppUserRepository>())
            ..loadData(activityToChange: activity);
        },
        child: OverviewInputContent(isInFlowContext: isInFlowContext),
      ),
    );
  }
}
