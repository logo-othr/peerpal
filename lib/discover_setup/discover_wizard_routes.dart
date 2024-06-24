import 'package:flutter/material.dart';
import 'package:peerpal/discover_feed_v2/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_activities/view/discover_activities_page.dart';
import 'package:peerpal/discover_setup/pages/discover_age/view/discover_age_page.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/view/discover_communication_page.dart';
import 'package:peerpal/discover_setup/pages/discover_location/view/discover_location_page.dart';

List<Page> onGenerateDiscoverWizardPages(
    PeerPALUser userInformation, List<Page<dynamic>> pages) {
  return [
    DiscoverAgePage.page(isInFlowContext: true),
    if (userInformation.discoverToAge != null &&
        userInformation.discoverFromAge != null)
      DiscoverActivitiesPage.page(isInFlowContext: true),
    if (userInformation.discoverActivitiesCodes != null)
      DiscoverLocationPage.page(isInFlowContext: true),
    if (userInformation.discoverLocations != null)
      DiscoverCommunicationPage.page(isInFlowContext: true),
  ];
}
