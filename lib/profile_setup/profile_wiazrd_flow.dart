import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/home/routes/routes.dart';
import 'package:peerpal/peerpal_user/domain/peerpal_user.dart';

class ProfileSetupFlow extends StatelessWidget {
  final PeerPALUser flowState;

  const ProfileSetupFlow(this.flowState);

  static Route<PeerPALUser> route(PeerPALUser flowSate) {
    return MaterialPageRoute(builder: (_) => ProfileSetupFlow(flowSate));
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
