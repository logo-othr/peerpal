import 'package:flutter/widgets.dart';
import 'package:peerpal/app/app.dart';
import 'package:peerpal/authentication/presentation/presentation.dart';
import 'package:peerpal/home/view/home_page.dart';

List<Page> onGenerateAuthenticationPages(
    AppAuthenticationStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppAuthenticationStatus.authenticated:
      return [HomePage.page()];
    case AppAuthenticationStatus.unauthenticated:
    default:
      return [LoginPage.page()];
  }
}
