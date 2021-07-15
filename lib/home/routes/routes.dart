import 'package:flutter/material.dart';
import 'package:peerpal/home/view/home_page.dart';
import 'package:peerpal/profile_wizard_flow/pages/age_selection/view/wizard_age_select.dart';
import 'package:peerpal/repository/models/app_user.dart';

List<Page> onGenerateHomeViewPages(AppUser appUser, List<Page<dynamic>> pages) {
  return [
    AgeSelection.page(),
    if (appUser.name != '') MyTabView.page(),
  ];
}
