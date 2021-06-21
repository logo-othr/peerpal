import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/profile_wizard_flow/models/profile.dart';
import 'package:peerpal/profile_wizard_flow/pages/age_selection/wizard_age_select.dart';
import 'package:peerpal/profile_wizard_flow/pages/start_profile_wizard/start_profile_wizard_screen.dart';

class ProfileWizardFlow extends StatelessWidget {
  static Route<ProfileWizardState> route() {
    return MaterialPageRoute(builder: (_) => ProfileWizardFlow());
  }

  @override
  Widget build(BuildContext context) {
    return const FlowBuilder<Profile>(
      state: Profile(),
      onGeneratePages: onGenerateProfileWizardPages,
    );
  }
}

List<Page> onGenerateProfileWizardPages(Profile profile, List<Page> pages) {
  final age = profile.age;
  return [
    ProfileWizardScreen.page(),
   if (age != null) AgeSelection.page(),
  ];
}

enum ProfileWizardState {
  initial,
  ageSelectComplete,
}
