import 'package:flutter/material.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_activities/view/discover_activities_page.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_age/view/discover_age_page.dart';
import 'package:peerpal/repository/models/user_information.dart';

List<Page> onGenerateDiscoverWizardPages(
    UserInformation userInformation, List<Page<dynamic>> pages) {
  return [
    DiscoverAgePage.page(isInFlowContext: true),
    if (userInformation.discoverToAge != null &&
        userInformation.discoverFromAge != null)
      DiscoverActivitiesPage.page(isInFlowContext: true),
  ];
}