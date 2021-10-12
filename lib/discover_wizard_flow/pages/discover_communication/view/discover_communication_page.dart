import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/discover_wizard_flow/base_wizard_cubit.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_communication/cubit/discover_communication_cubit.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_communication/view/discover_communication_content.dart';
import 'package:peerpal/repository/app_user_repository.dart';

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
      onWillPop: () async => false,
        child: BlocProvider<BaseWizardCubit<DiscoverCommunicationState>>.value(
          value: DiscoverCommunicationCubit(context.read<AppUserRepository>())..loadData(),
          child: DiscoverCommunicationContent(isInFlowContext: isInFlowContext),
        ),
    );
  }
}