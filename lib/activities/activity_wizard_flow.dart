import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/activities/activity_wizard_routes.dart';
import 'package:peerpal/repository/models/activity.dart';

class ActivityWizardFlow extends StatelessWidget {
  final Activity flowState;

  const ActivityWizardFlow(this.flowState);

  static Route<Activity> route(Activity flowSate) {
    return MaterialPageRoute(builder: (_) => ActivityWizardFlow(flowSate));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: FlowBuilder<Activity>(
        state: flowState,
        onGeneratePages: onGenerateActivityWizardPages,
      ),
    );
  }
}
