import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/discover_setup/pages/discover_location/cubit/discover_location_cubit.dart';
import 'package:peerpal/discover_setup/pages/discover_location/view/discover_location_content.dart';
import 'package:peerpal/injection.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/get_user_usecase.dart';

class DiscoverLocationPage extends StatelessWidget {
  final bool isInFlowContext;

  const DiscoverLocationPage({required this.isInFlowContext});

  static MaterialPage<void> page({required bool isInFlowContext}) {
    return MaterialPage<void>(
        child: DiscoverLocationPage(isInFlowContext: isInFlowContext));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider.value(
        value: DiscoverLocationCubit(
            context.read<AppUserRepository>(), sl<GetAuthenticatedUser>())
          ..loadData(),
        child: DiscoverLocationContent(isInFlowContext: isInFlowContext),
      ),
    );
  }
}