import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/authentication/presentation/passwort_reset/cubit/password_reset_cubit.dart';
import 'package:peerpal/authentication/presentation/passwort_reset/view/password_reset_form.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';

class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const PasswordResetPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        "PeerPAL",
        hasBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) =>
              ResetPasswordCubit(context.read<AuthenticationRepository>()),
          child: const ResetPasswordForm(),
        ),
      ),
    );
  }
}
