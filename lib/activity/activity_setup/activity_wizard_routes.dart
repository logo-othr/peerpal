import 'package:flutter/material.dart';
import 'package:peerpal/activity/activity_setup/activity_selection/view/activity_selection_page.dart';
import 'package:peerpal/repository/models/activity.dart';

import 'activity_date/view/activity_date_input_page.dart';
import 'activity_invitation/view/activity_invitation_input_page.dart';
import 'activity_location/view/activity_location_input_page.dart';
import 'activity_overview_page/view/activity_overview_input_page.dart';

List<Page> onGenerateActivityWizardPages(
    Activity activityFlowState, List<Page<dynamic>> pages) {
  return [
    ActivitySelectionPage.page(isInFlowContext: true),
    if (activityFlowState.name != null && activityFlowState.code != null)
      ActivitySelectDatePage.page(isInFlowContext: true),
    if (activityFlowState.date != null)
      LocationInputPage.page(isInFlowContext: true),
    if (activityFlowState.location != null)
      InvitationInputPage.page(isInFlowContext: true),
    if (activityFlowState.invitationIds != null)
      OverviewInputPage.page(isInFlowContext: true),
  ];
}
