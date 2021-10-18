import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/home/routes/routes.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

class ProfileWizardFlow extends StatelessWidget {
  final PeerPALUser flowState;

  const ProfileWizardFlow(this.flowState);

  static Route<PeerPALUser> route(PeerPALUser flowSate) {
    return MaterialPageRoute(builder: (_) => ProfileWizardFlow(flowSate));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: FlowBuilder<PeerPALUser>(
        state: flowState,
        onGeneratePages: onGenerateProfileWizardPages,
      ),
    );
  }
}
