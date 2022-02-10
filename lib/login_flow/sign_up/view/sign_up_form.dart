import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:peerpal/login_flow/sign_up/models/password_model.dart';
import 'package:peerpal/login_flow/sign_up/sign_up.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pop();
        } else         if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                  content: Text((state.errorMessage.isEmpty
                      ? 'Fehler bei der Registierung.'
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
                Align(
                    alignment: Alignment.centerLeft,
                    child: CustomPeerPALHeading1("Konto erstellen")),
                const SizedBox(height: 30.0),
                _EmailInputField(),
                const SizedBox(height: 8.0),
                new _PasswordInputField(),
                const SizedBox(height: 8.0),
                _ConfirmPasswordInputField(),
                const SizedBox(height: 20.0),
                _SignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          style: TextStyle(fontSize: 22),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.mail),
            labelText: 'E-Mail-Adresse',
            helperText: '',
            errorText: state.email.invalid ? 'Ungültige E-Mail-Adresse' : null,
          ),
          onChanged: (email) => context.read<SignupCubit>().changeEmail(email),
          keyboardType: TextInputType.emailAddress,
        );
      },
    );
  }
}

class _PasswordInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.password != current.password || previous.visible != current.visible,
      builder: (context, state) {
        String? errorText = "";
        var errorState = state.password.error;
        switch (errorState) {
          case PasswordError.invalid:
            errorText = "Ungültiges Passwort";
            break;
          case PasswordError.veryWeak:
            errorText = "Das Passwort ist deutlich zu schwach.";
            break;
          case PasswordError.weak:
            errorText = "Das Passwort ist zu schwach.";
            break;
          case PasswordError.toShort:
            errorText = "Das Passwort muss mindestens 8 Zeichen haben.";
            break;
          case PasswordError.toLong:
            errorText = "Das Passwort darf nicht mehr als 62 Zeichen haben.";
            break;
          default:
            errorText = null;
            break;
        }
        return new TextField(
          style: TextStyle(fontSize: 22),
          onChanged: (password) =>
              context.read<SignupCubit>().changePassword(password),
          obscureText: context.read<SignupCubit>().isVisible(0),
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                    context.read<SignupCubit>().isVisible(0)? Icons.visibility_off : Icons.visibility),
                onPressed: (){
                  context.read<SignupCubit>().changeVisibility(0);
                },

              ),
              labelText: 'Passwort',
              helperText: '',
              errorText: errorText),
        );
      },
    );
  }
}

class _ConfirmPasswordInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) =>
      previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword || previous.confirmVisible != current.confirmVisible,
      builder: (context, state) {
        return TextField(
          style: TextStyle(fontSize: 22),
          onChanged: (confirmPassword) => context
              .read<SignupCubit>()
              .changeConfirmedPassword(confirmPassword),
          obscureText: context.read<SignupCubit>().isVisible(1),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                  context.read<SignupCubit>().isVisible(1)? Icons.visibility_off : Icons.visibility),
              onPressed: (){
                context.read<SignupCubit>().changeVisibility(1);
              },

            ),
            labelText: 'Passwort bestätigen',
            helperText: '',
            errorText: state.confirmedPassword.invalid
                ? 'Passwort stimmt nicht überein'
                : null,
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : CustomPeerPALButton(
            onPressed: state.status.isValidated
                ? () => context.read<SignupCubit>().submitSignupForm()
                : null,
            text: "Registrieren");
      },
    );
  }
}
