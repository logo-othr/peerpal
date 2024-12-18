import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/presentation/activity_setup/activity_wizard_routes.dart';

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
