import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activity/domain/repository/activity_repository.dart';
import 'package:peerpal/activity/presentation/activity_setup/activity_invitation/cubit/activity_invitation_cubit.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';

import 'activity_invitation_input_content.dart';

class InvitationInputPage extends StatelessWidget {
  final bool isInFlowContext;

  InvitationInputPage({required this.isInFlowContext});

  static MaterialPage<void> page({required bool isInFlowContext}) {
    return MaterialPage<void>(
        child: InvitationInputPage(isInFlowContext: isInFlowContext));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: BlocProvider(
        create: (_) {
          return InvitationInputCubit(context.read<AppUserRepository>(),
              context.read<ActivityRepository>())
            ..getData();
        },
        child: InviteFriendsContent(isInFlowContext: isInFlowContext),
      ),
    );
  }
}
