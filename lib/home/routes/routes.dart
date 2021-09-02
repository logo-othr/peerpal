import 'package:flutter/material.dart';
import 'package:peerpal/home/view/home_page.dart';
import 'package:peerpal/profile_wizard_flow/pages/age_input_page/view/age_input_page.dart';
import 'package:peerpal/profile_wizard_flow/pages/name_input_page/view/name_input_page.dart';
import 'package:peerpal/repository/models/user_information.dart';

List<Page> onGenerateHomeViewPages(
    UserInformation userInformation, List<Page<dynamic>> pages) {
  return [
    AgeSelection.page(),
    if (userInformation.age != null) NameInputPage.page(),
    if (userInformation.name != null) MyTabView.page(),
  ];
}
