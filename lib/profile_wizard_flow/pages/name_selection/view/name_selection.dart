import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/profile_wizard_flow/pages/name_selection/cubit/name_selection_cubit.dart';
import 'package:peerpal/profile_wizard_flow/pages/name_selection/view/name_selection_form.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';

class NameSelectionPage extends StatelessWidget {
  static MaterialPage<void> page() {
    return MaterialPage<void>(child: NameSelectionPage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: CustomAppBar("Username"),
        body: BlocProvider(
          create: (_) {
            return NameSelectionCubit(context.read<AppUserRepository>());
          },
          child: NameSelectionForm(),
        ),
      ),
    );
  }
}
