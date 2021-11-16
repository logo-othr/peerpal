import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/discover_wizard_flow/discover_wizard_routes.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

class DiscoverWizardFlow extends StatelessWidget {
  final PeerPALUser flowState;

  const DiscoverWizardFlow(this.flowState);

  static Route<PeerPALUser> route(PeerPALUser flowSate) {
    return MaterialPageRoute(builder: (_) => DiscoverWizardFlow(flowSate));
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
