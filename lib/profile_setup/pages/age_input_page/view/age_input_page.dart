import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/injection.dart';
import 'package:peerpal/profile_setup/pages/age_input_page/cubit/age_input_cubit.dart';
import 'package:peerpal/profile_setup/pages/age_input_page/view/age_input_content.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/get_user_usecase.dart';

class AgeInputPage extends StatelessWidget {
  final bool isInFlowContext;

  AgeInputPage({required this.isInFlowContext});

  static MaterialPage<void> page({required bool isInFlowContext}) {
    return MaterialPage<void>(
        child: AgeInputPage(isInFlowContext: isInFlowContext));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider(
        create: (_) {
          return AgeInputCubit(
              context.read<AppUserRepository>(), sl<GetAuthenticatedUser>());
        },
        child: AgeInputContent(isInFlowContext: isInFlowContext),
      ),
    );
  }
}