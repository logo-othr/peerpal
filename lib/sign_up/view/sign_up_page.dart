import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/sign_up/sign_up.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("PeerPAL", hasBackButton: true,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => SignupCubit(context.read<AppUserRepository>()),
          child: const SignUpForm(),
        ),
      ),
    );
  }
}
