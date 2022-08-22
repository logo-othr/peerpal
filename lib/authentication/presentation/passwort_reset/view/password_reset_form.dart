import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:peerpal/authentication/presentation/passwort_reset/cubit/password_reset_cubit.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class ResetPasswordForm extends StatelessWidget {
  const ResetPasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state.formValidationStatus.isSubmissionFailure ||
            state.formValidationStatus.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                  content: Text((state.submissionMessage.isEmpty
                      ? 'Fehler beim Senden'
                      : state.submissionMessage))),
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
                CustomPeerPALHeading1('Passwort vergessen'),
                const SizedBox(height: 30.0),
                _EmailInputField(),
                const SizedBox(height: 20.0),
                _ResetButton(),
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
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
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
          key: const Key('reset_email_field'),
          onChanged: (email) =>
              context.read<ResetPasswordCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
        );
      },
    );
  }
}

class _ResetButton extends StatefulWidget {
  @override
  State<_ResetButton> createState() => _ResetButtonState();
}

class _ResetButtonState extends State<_ResetButton> {
  bool disabled = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      buildWhen: (previous, current) =>
          previous.formValidationStatus != current.formValidationStatus,
      builder: (context, state) {
        if (state.formValidationStatus.isSubmissionInProgress) {
          return const CircularProgressIndicator();
        } else if (disabled) {
          return Text(
              "Sie haben eine E-Mail für den Passwort-Reset erhalten. Bitte prüfen Sie ihre E-Mails und ihren E-Mail-Spam-Ordner.");
        } else {
          return CustomPeerPALButton(
              onPressed: state.formValidationStatus.isValidated
                  ? () {
                      context.read<ResetPasswordCubit>().resetPassword();
                      setState(() {
                        disabled = true;
                      });
                    }
                  : null,
              text: 'Reset Password');
        }
      },
    );
  }
}
