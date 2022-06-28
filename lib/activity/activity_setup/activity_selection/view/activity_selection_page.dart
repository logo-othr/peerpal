import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activity/activity_setup/activity_selection/cubit/activity_selection_cubit.dart';
import 'package:peerpal/activity/data/repository/activity_repository.dart';

//platzhalter

import 'activity_selection_content.dart';

class ActivitySelectionPage extends StatelessWidget {
  final bool isInFlowContext;

  ActivitySelectionPage({required this.isInFlowContext});

  static MaterialPage<void> page({required bool isInFlowContext}) {
    return MaterialPage<void>(
        child: ActivitySelectionPage(isInFlowContext: isInFlowContext));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider(
        create: (_) {
          return ActivitySelectionCubit(context.read<ActivityRepository>())
            ..loadData();
        },
        child: ActivitySelectionContent(isInFlowContext: isInFlowContext),
      ),
    );
  }
}
