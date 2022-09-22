import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activity/data/repository/activity_repository.dart';
import 'package:peerpal/activity/presentation/activity_setup/activity_location/cubit/activity_location_cubit.dart';
import 'package:provider/src/provider.dart';

import 'activity_location_input_content.dart';

class LocationInputPage extends StatelessWidget {
  final bool isInFlowContext;

  LocationInputPage({required this.isInFlowContext});

  static MaterialPage<void> page({required bool isInFlowContext}) {
    return MaterialPage<void>(
        child: LocationInputPage(isInFlowContext: isInFlowContext));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: BlocProvider(
        create: (_) {
          return ActivityLocationCubit(context.read<ActivityRepository>())
            ..loadData();
        },
        child: LocationInputContent(isInFlowContext: isInFlowContext),
      ),
    );
  }
}
