import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activities/activity_overview_page/cubit/activity_overview_cubit.dart';
import 'package:peerpal/repository/activity_repository.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'activity_overview_input_content.dart';

class OverviewInputPage extends StatelessWidget {
  final bool isInFlowContext;

  OverviewInputPage({required this.isInFlowContext});

  static MaterialPage<void> page({required bool isInFlowContext}) {
    return MaterialPage<void>(
        child: OverviewInputPage(isInFlowContext: isInFlowContext));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider(
        create: (_) {
          return OverviewInputCubit(context.read<ActivityRepository>(), context.read<AppUserRepository>())..loadData();
        },
        child: OverviewInputContent(isInFlowContext: isInFlowContext),
      ),
    );
  }
}