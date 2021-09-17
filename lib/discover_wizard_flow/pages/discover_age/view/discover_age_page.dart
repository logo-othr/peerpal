import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_age/cubit/discover_age_cubit.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_age/view/discover_age_content.dart';
import 'package:peerpal/profile_wizard_flow/pages/age_input_page/cubit/age_input_cubit.dart';
import 'package:peerpal/profile_wizard_flow/pages/age_input_page/view/age_input_content.dart';
import 'package:peerpal/repository/app_user_repository.dart';

class DiscoverAgePage extends StatelessWidget {
  final bool isInFlowContext;

  const DiscoverAgePage({required this.isInFlowContext});

  static MaterialPage<void> page({required bool isInFlowContext}) {
    return MaterialPage<void>(
        child: DiscoverAgePage(isInFlowContext: isInFlowContext));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider(
        create: (_) {
          return DiscoverAgeCubit(context.read<AppUserRepository>());
        },
        child: DiscoverAgeContent(isInFlowContext: isInFlowContext),
      ),
    );
  }
}