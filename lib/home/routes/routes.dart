import 'package:flutter/material.dart';
import 'package:peerpal/profile_setup/pages/age_input_page/view/age_input_page.dart';
import 'package:peerpal/profile_setup/pages/name_input_page/view/name_input_page.dart';
import 'package:peerpal/profile_setup/pages/phone_input_page/view/phone_input_page.dart';
import 'package:peerpal/profile_setup/pages/profile_picture_input_page/view/profile_picture_input_page.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

List<Page> onGenerateProfileWizardPages(
    PeerPALUser userInformation, List<Page<dynamic>> pages) {
  return [
    AgeInputPage.page(isInFlowContext: true),
    if (userInformation.age != null) NameInputPage.page(isInFlowContext: true),
    if (userInformation.name != null)
      PhoneInputPage.page(isInFlowContext: true,pastPhone: ""),
    if (userInformation.phoneNumber != null)
      ProfilePictureInputPage.page(isInFlowContext: true),
  ];
}
