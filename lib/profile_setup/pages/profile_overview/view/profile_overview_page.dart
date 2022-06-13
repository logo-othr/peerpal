import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/injection.dart';
import 'package:peerpal/profile_setup/pages/profile_overview/cubit/profile_overview_cubit.dart';
import 'package:peerpal/profile_setup/pages/profile_overview/view/profile_overview_content.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/get_user_usecase.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';

class ProfileOverviewPage extends StatelessWidget {
  static MaterialPage<void> page() {
    return MaterialPage<void>(child: ProfileOverviewPage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: CustomAppBar("Überblick", hasBackButton: false),
        body: BlocProvider.value(
          value: ProfileOverviewCubit(
              context.read<AppUserRepository>(), sl<GetAuthenticatedUser>())
            ..loadData(),
          child: ProfileOverviewContent(),
        ),
      ),
    );
  }
}
