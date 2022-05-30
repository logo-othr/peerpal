import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activities/activity_date/cubit/activity_date_cubit.dart';
import 'package:peerpal/repository/activity_repository.dart';
//platzhalter

import 'activity_date_input_content.dart';

class ActivitySelectDatePage extends StatelessWidget {
   final bool isInFlowContext;

  ActivitySelectDatePage({required this.isInFlowContext});

  static MaterialPage<void> page({required bool isInFlowContext}) {
    return MaterialPage<void>(
        child: ActivitySelectDatePage(isInFlowContext: isInFlowContext));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider(
        create: (_) {
          return DateInputCubit(context.read<ActivityRepository>())..load();
        },
        child: DateInputContent(isInFlowContext: isInFlowContext),
      ),
    );
  }
}