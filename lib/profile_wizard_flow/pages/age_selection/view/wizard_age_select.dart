import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/profile_wizard_flow/pages/age_selection/cubit/age_selection_cubit.dart';
import 'package:peerpal/profile_wizard_flow/pages/age_selection/view/age_selection_content.dart';
import 'package:peerpal/repository/auth_repository.dart';

class AgeSelection extends StatelessWidget {
  static MaterialPage<void> page() {
    return MaterialPage<void>(child: AgeSelection());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider(
        create: (_) {
          return AgeSelectionCubit(context.read<AuthenticationRepository>());
        },
        child: AgeSelectionContent(),
      ),
    );
  }
}
