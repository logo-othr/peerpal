import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/domain/location/location_repository.dart';
import 'package:peerpal/discover_feed_v2/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/discover_setup/pages/discover_location/cubit/discover_location_cubit.dart';
import 'package:peerpal/discover_setup/pages/discover_location/view/discover_location_content.dart';
import 'package:peerpal/setup.dart';

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
      onWillPop: () async => true,
      child: BlocProvider.value(
        value: DiscoverLocationCubit(context.read<AppUserRepository>(),
            sl<GetAuthenticatedUser>(), sl<LocationRepository>())
          ..loadData(),
        child: DiscoverLocationContent(isInFlowContext: isInFlowContext),
      ),
    );
  }
}
