import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/discover/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/discover_wizard_routes.dart';

class DiscoverSetupFlow extends StatelessWidget {
  final PeerPALUser flowState;

  const DiscoverSetupFlow(this.flowState);

  static Route<PeerPALUser> route(PeerPALUser flowSate) {
    return MaterialPageRoute(builder: (_) => DiscoverSetupFlow(flowSate));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: FlowBuilder<PeerPALUser>(
        state: flowState,
        onGeneratePages: onGenerateDiscoverWizardPages,
      ),
    );
  }
}
