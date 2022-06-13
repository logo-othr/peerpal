import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/discover_setup/pages/discover_interests_overview/cubit/discover_interests_overview_cubit.dart';
import 'package:peerpal/discover_setup/pages/discover_interests_overview/view/discover_interests_overview_content.dart';
import 'package:peerpal/injection.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/get_user_usecase.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';

class DiscoverInterestsOverviewPage extends StatelessWidget {
  static MaterialPage<void> page() {
    return MaterialPage<void>(child: DiscoverInterestsOverviewPage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: CustomAppBar("Überblick", hasBackButton: false),
        body: BlocProvider.value(
          value: DiscoverInterestsOverviewCubit(
              context.read<AppUserRepository>(), sl<GetAuthenticatedUser>())
            ..loadData(),
          child: DiscoverInterestsOverviewContent(),
        ),
      ),
    );
  }
}
