import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/profile_wizard_flow/pages/name_input_page/cubit/name_input_cubit.dart';
import 'package:peerpal/profile_wizard_flow/pages/name_input_page/view/name_input_content.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';

class NameInputPage extends StatelessWidget {
  static MaterialPage<void> page() {
    return MaterialPage<void>(child: NameInputPage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: CustomAppBar("Username", hasBackButton: true,),
        body: BlocProvider(
          create: (_) {
            return NameInputCubit(context.read<AppUserRepository>());
          },
          child: NameInputContent(),
        ),
      ),
    );
  }
}
