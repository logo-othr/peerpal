import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/profile_wizard_flow/pages/phone_input_page/cubit/phone_input_cubit.dart';
import 'package:peerpal/profile_wizard_flow/pages/phone_input_page/view/phone_input_content.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';


class PhoneInputPage extends StatelessWidget {

  final bool isInFlowContext;

  PhoneInputPage({required this.isInFlowContext});

  static MaterialPage<void> page({required bool isInFlowContext}) {
    return MaterialPage<void>(
        child: PhoneInputPage(isInFlowContext: isInFlowContext));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: CustomAppBar("Telefonnummer", hasBackButton: true,),
        body: BlocProvider(
          create: (_) {
            return PhoneInputCubit(context.read<AppUserRepository>());
          },
          child: PhoneInputContent(isInFlowContext: isInFlowContext),
        ),
      ),
    );
  }
}
