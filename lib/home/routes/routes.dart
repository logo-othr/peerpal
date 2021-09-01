import 'package:flutter/material.dart';
import 'package:peerpal/home/view/home_page.dart';
import 'package:peerpal/profile_wizard_flow/pages/age_selection/view/wizard_age_select.dart';
import 'package:peerpal/profile_wizard_flow/pages/name_selection/view/name_selection.dart';
import 'package:peerpal/repository/models/user_information.dart';

List<Page> onGenerateHomeViewPages(
    UserInformation userInformation, List<Page<dynamic>> pages) {
  return [
    AgeSelection.page(),
    if (userInformation.age != null) NameSelectionPage.page(),
    if (userInformation.name != null) MyTabView.page(),
  ];
}
