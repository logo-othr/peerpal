import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/profile_wizard_flow/pages/phone_input_page/cubit/phone_input_cubit.dart';
import 'package:peerpal/profile_wizard_flow/pages/phone_input_page/view/phone_input_content.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';


class PhoneInputPage extends StatelessWidget {
  static MaterialPage<void> page() {
    return MaterialPage<void>(child: PhoneInputPage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: CustomAppBar("Telefonnummer"),
        body: BlocProvider(
          create: (_) {
            return PhoneInputCubit(context.read<AppUserRepository>());
          },
          child: PhoneInputContent(),
        ),
      ),
    );
  }
}
