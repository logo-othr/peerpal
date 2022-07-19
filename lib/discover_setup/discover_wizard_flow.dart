import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/discover_setup/discover_wizard_routes.dart';
import 'package:peerpal/peerpal_user/domain/peerpal_user.dart';

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
