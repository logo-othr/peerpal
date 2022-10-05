import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/cubit/discover_communication_cubit.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/view/discover_communication_content.dart';
import 'package:peerpal/setup.dart';

class DiscoverCommunicationPage extends StatelessWidget {
  final bool isInFlowContext;

  const DiscoverCommunicationPage({required this.isInFlowContext});

  static MaterialPage<void> page({required bool isInFlowContext}) {
    return MaterialPage<void>(
        child: DiscoverCommunicationPage(isInFlowContext: isInFlowContext));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: BlocProvider.value(
        value: DiscoverCommunicationCubit(
            context.read<AppUserRepository>(), sl<GetAuthenticatedUser>())
          ..loadData(),
        child: DiscoverCommunicationContent(isInFlowContext: isInFlowContext),
      ),
    );
  }
}
