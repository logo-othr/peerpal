import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/discover/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/profile_setup/presentation/phone_input_page/cubit/phone_input_cubit.dart';
import 'package:peerpal/profile_setup/presentation/phone_input_page/view/phone_input_content.dart';
import 'package:peerpal/setup.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';

class PhoneInputPage extends StatelessWidget {
  final bool isInFlowContext;
  final String pastPhone;

  PhoneInputPage({required this.isInFlowContext, required this.pastPhone});

  static MaterialPage<void> page(
      {required bool isInFlowContext, required String pastPhone}) {
    return MaterialPage<void>(
        child: PhoneInputPage(
      isInFlowContext: isInFlowContext,
      pastPhone: pastPhone,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: CustomAppBar(
          "PeerPAL",
          hasBackButton: true,
        ),
        body: BlocProvider(
          create: (_) {
            return PhoneInputCubit(
                context.read<AppUserRepository>(), sl<GetAuthenticatedUser>());
          },
          child: PhoneInputContent(
            isInFlowContext: isInFlowContext,
            pastPhone: pastPhone,
          ),
        ),
      ),
    );
  }
}
