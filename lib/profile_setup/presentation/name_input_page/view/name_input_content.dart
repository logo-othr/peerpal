import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/profile_setup/presentation/name_input_page/cubit/name_input_cubit.dart';
import 'package:peerpal/profile_setup/presentation/name_input_page/widgets/username_form_field.dart';
import 'package:peerpal/profile_setup/presentation/name_input_page/widgets/username_submit_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class NameInputContent extends StatelessWidget {
  final bool isInFlowContext;

  const NameInputContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsernameCubit, UsernameState>(
      builder: (context, state) {
        if (state is UsernameStateLoaded) {
          return UsernameForm(
              isInFlowContext: isInFlowContext,
              currentUsername: state.currentUser.name ?? '');
        } else
          return CircularProgressIndicator();
      },
    );
  }
}

class UsernameForm extends StatelessWidget {
  final bool isInFlowContext;
  final String currentUsername;

  const UsernameForm(
      {Key? key, required this.isInFlowContext, required this.currentUsername})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsernameCubit, UsernameState>(
      listener: _errorStateListener,
      child: _NameFormContent(
          isInFlowContext: isInFlowContext, pastName: currentUsername),
    );
  }

  void _errorStateListener(context, state) {
    if (state.formValidationStatus.isSubmissionFailure) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
              content: Text((state.errorMessage.isEmpty
                  ? 'Fehler beim Speichern.'
                  : state.errorMessage))),
        );
    }
  }
}

class _NameFormContent extends StatelessWidget {
  final isInFlowContext;
  final pastName;

  const _NameFormContent(
      {Key? key, required this.isInFlowContext, required this.pastName})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -1 / 3),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 16.0),
              CustomPeerPALHeading1('Wie ist dein Name?'),
              const SizedBox(height: 120),
              UsernameFormField(
                  isInFlowContext: isInFlowContext, pastName: pastName),
              const SizedBox(height: 190),
              UsernameSubmitButton(isInFlowContext),
            ],
          ),
        ),
      ),
    );
  }
}
