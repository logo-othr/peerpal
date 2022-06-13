import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activities/activity_public_overview_page/cubit/activity_public_overview_cubit.dart';
import 'package:peerpal/activities/activity_public_overview_page/view/activity_public_overview_content.dart';
import 'package:peerpal/login_flow/persistence/authentication_repository.dart';
import 'package:peerpal/repository/activity_repository.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/activity.dart';


class ActivityPublicOverviewPage extends StatelessWidget {
  Activity activity;
  ActivityPublicOverviewPage({required this.activity});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider(
        create: (_) {
          return ActivityPublicOverviewCubit(context.read<ActivityRepository>(),
              context.read<AppUserRepository>(), context.read<AuthenticationRepository>())
            ..loadData(activity);
        },
        child: ActivityPublicOverviewContent(),
      ),
    );
  }
}
