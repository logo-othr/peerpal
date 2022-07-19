import 'package:flutter/material.dart';
import 'package:peerpal/peerpal_user/domain/peerpal_user.dart';
import 'package:peerpal/profile_setup/presentation/age_input_page/view/age_input_page.dart';
import 'package:peerpal/profile_setup/presentation/name_input_page/view/name_input_page.dart';
import 'package:peerpal/profile_setup/presentation/phone_input_page/view/phone_input_page.dart';
import 'package:peerpal/profile_setup/presentation/profile_picture_input_page/view/profile_picture_input_page.dart';

List<Page> onGenerateProfileWizardPages(
    PeerPALUser userInformation, List<Page<dynamic>> pages) {
  return [
    AgeInputPage.page(isInFlowContext: true),
    if (userInformation.age != null) NameInputPage.page(isInFlowContext: true),
    if (userInformation.name != null)
      PhoneInputPage.page(isInFlowContext: true, pastPhone: ""),
    if (userInformation.phoneNumber != null)
      ProfilePictureInputPage.page(isInFlowContext: true),
  ];
}
