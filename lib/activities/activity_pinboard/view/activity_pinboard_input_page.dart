import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activities/activity_pinboard/cubit/activity_pinboard_cubit.dart';
import 'package:peerpal/repository/activity_repository.dart';
import 'package:peerpal/repository/app_user_repository.dart';

import 'activity_pinboard_input_content.dart';

class PinboardInputPage extends StatelessWidget {
  final bool isInFlowContext;

  PinboardInputPage({required this.isInFlowContext});

  static MaterialPage<void> page({required bool isInFlowContext}) {
    return MaterialPage<void>(
        child: PinboardInputPage(isInFlowContext: isInFlowContext));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider(
        create: (_) {
          return PinboardInputCubit(context.read<ActivityRepository>());
        },
        child: PinboardInputContent(isInFlowContext: isInFlowContext),
      ),
    );
  }
}