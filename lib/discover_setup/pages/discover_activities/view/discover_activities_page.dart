import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/discover_setup/pages/discover_activities/cubit/discover_activities_cubit.dart';
import 'package:peerpal/discover_setup/pages/discover_activities/view/discover_activities_content.dart';
import 'package:peerpal/injection.dart';
import 'package:peerpal/repository/activity_repository.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/get_user_usecase.dart';

class DiscoverActivitiesPage extends StatelessWidget {
  final bool isInFlowContext;

  const DiscoverActivitiesPage({required this.isInFlowContext});

  static MaterialPage<void> page({required bool isInFlowContext}) {
    return MaterialPage<void>(
        child: DiscoverActivitiesPage(isInFlowContext: isInFlowContext));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider.value(
        value: DiscoverActivitiesCubit(context.read<AppUserRepository>(),
            context.read<ActivityRepository>(), sl<GetAuthenticatedUser>())
          ..loadData(),
        child: DiscoverActivitiesContent(isInFlowContext: isInFlowContext),
      ),
    );
  }
}