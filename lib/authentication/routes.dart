import 'package:flutter/widgets.dart';
import 'package:peerpal/account_setup/view/setup_page.dart';
import 'package:peerpal/app/presentation/app/bloc/app_bloc.dart';
import 'package:peerpal/authentication/presentation/presentation.dart';

List<Page> onGenerateAuthenticationPages(
    AppAuthenticationStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppAuthenticationStatus.authenticated:
      return [SetupPage.page()];
    case AppAuthenticationStatus.unauthenticated:
    default:
      return [LoginPage.page()];
  }
}
