import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activity/data/repository/activity_reminder_repository.dart';
import 'package:peerpal/activity/data/repository/activity_repository.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/presentation/activity_setup/activity_public_overview_page/cubit/activity_public_overview_cubit.dart';
import 'package:peerpal/activity/presentation/activity_setup/activity_public_overview_page/view/activity_public_overview_content.dart';
import 'package:peerpal/login_flow/persistence/authentication_repository.dart';
import 'package:peerpal/peerpal_user/data/repository/app_user_repository.dart';

class ActivityPublicOverviewPage extends StatelessWidget {
  Activity activity;

  ActivityPublicOverviewPage({required this.activity});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider(
        create: (_) {
          return ActivityPublicOverviewCubit(
              context.read<ActivityRepository>(),
              context.read<AppUserRepository>(),
              context.read<AuthenticationRepository>(),
              context.read<ActivityReminderRepository>())
            ..loadData(activity);
        },
        child: ActivityPublicOverviewContent(),
      ),
    );
  }
}
