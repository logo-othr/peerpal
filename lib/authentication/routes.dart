import 'package:flutter/widgets.dart';
import 'package:peerpal/app/app.dart';
import 'package:peerpal/home/view/home_page.dart';
import 'package:peerpal/login_flow/presentation/presentation.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
    default:
      return [LoginPage.page()];
  }
}
