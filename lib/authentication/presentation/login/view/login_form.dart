import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:peerpal/authentication/presentation/passwort_reset/view/passwort_reset_page.dart';
import 'package:peerpal/authentication/presentation/presentation.dart';
import 'package:peerpal/data/resources/colors.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.formValidationStatus.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                  content: Text((state.errorMessage.isEmpty
                      ? 'Fehler beim Login'
                      : state.errorMessage))),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16.0),
                CustomPeerPALHeading1('Login'),
                const SizedBox(height: 30.0),
                _EmailInputField(),
                const SizedBox(height: 8.0),
                _PasswordInputField(),
                const SizedBox(height: 8.0),
                _PasswordForgetTextButton(),
                const SizedBox(height: 20.0),
                _LoginButton(),
                const SizedBox(height: 15.0),
                _Divider(),
                const SizedBox(height: 15.0),
                _SignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(45, 0, 0, 0),
            child: Divider(thickness: 1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: CustomPeerPALHeading4(
            'ODER',
            color: Colors.black,
          ),
        ),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 45, 0),
            child: Divider(thickness: 1),
          ),
        ),
      ],
    );
  }
}

class _PasswordForgetTextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
      child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
              onTap: () =>
                  Navigator.of(context).push<void>(PasswordResetPage.route()),
              child: CustomPeerPALHeading4(
                'Passwort vergessen?',
                color: primaryColor,
              ))),
    );
  }
}

class _EmailInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          style: const TextStyle(fontSize: 22),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.mail),
            labelText: 'E-Mail',
            helperText: '',
            errorText: state.email.invalid ? 'invalid email' : null,
          ),
          key: const Key('login_email_field'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
        );
      },
    );
  }
}

class _PasswordInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => changePasswordField(previous, current),
      builder: (context, state) {
        return TextField(
          style: const TextStyle(fontSize: 22),
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: context.read<LoginCubit>().isVisible(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(context.read<LoginCubit>().isVisible()
                  ? Icons.visibility_off
                  : Icons.visibility),
              onPressed: () {
                context.read<LoginCubit>().changeVisibility();
              },
            ),
            labelText: 'Passwort',
            helperText: '',
          ),
        );
      },
      key: const Key('login_password_field'),
    );
  }

  bool changePasswordField(LoginState previous, LoginState current) {
    return previous.password != current.password ||
        previous.visible != current.visible;
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.formValidationStatus != current.formValidationStatus,
      builder: (context, state) {
        return state.formValidationStatus.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : CustomPeerPALButton(
                onPressed: state.formValidationStatus.isValidated
                    ? () => {
                          context.read<LoginCubit>().login(),
                        }
                    : null,
                text: 'Login');
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPeerPALButton(
        onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
        text: 'Registrieren');
  }
}
