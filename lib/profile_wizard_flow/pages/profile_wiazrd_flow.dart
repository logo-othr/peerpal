import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/home/routes/routes.dart';
import 'package:peerpal/repository/models/user_information.dart';

class ProfileWizardFlow extends StatelessWidget {
  final UserInformation flowState;

  const ProfileWizardFlow(this.flowState);

  static Route<UserInformation> route(UserInformation flowSate) {
    return MaterialPageRoute(builder: (_) => ProfileWizardFlow(flowSate));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: FlowBuilder<UserInformation>(
        state: flowState,
        onGeneratePages: onGenerateProfileWizardPages,
      ),
    );
  }
}
