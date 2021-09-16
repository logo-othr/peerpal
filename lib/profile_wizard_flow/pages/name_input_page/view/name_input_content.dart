import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:peerpal/profile_wizard_flow/pages/name_input_page/cubit/name_input_cubit.dart';
import 'package:peerpal/repository/models/user_information.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class NameInputContent extends StatelessWidget {
  final bool isInFlowContext;

  NameInputContent({Key? key, required this.isInFlowContext}) : super(key: key);

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<NameInputCubit, NameInputState>(
      listener: (context, state) {
        if (state.formValidationStatus.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                  content: Text((state.errorMessage.isEmpty
                      ? "Fehler beim Speichern."
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
                CustomPeerPALHeading1("Name Input"),
                const SizedBox(height: 30.0),
                _UsernameInputField(),
                const SizedBox(height: 8.0),
                _NextButton(isInFlowContext),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UsernameInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NameInputCubit, NameInputState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
            style: const TextStyle(fontSize: 22),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.mail),
              labelText: 'Name',
              helperText: '',
              errorText: state.username.invalid ? 'invalid email' : null,
            ),
            key: const Key('name_selection_username_field'),
            onChanged: (username) =>
                context.read<NameInputCubit>().nameChanged(username),
            keyboardType: TextInputType.name);
      },
    );
  }
}

class _NextButton extends StatelessWidget {
  final isInFlowContext;

  _NextButton(this.isInFlowContext);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NameInputCubit, NameInputState>(
      buildWhen: (previous, current) =>
          previous.formValidationStatus != current.formValidationStatus,
      builder: (context, state) {
        return state.formValidationStatus.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : CustomPeerPALButton(
                key: const Key('name_selection_next_button'),
                onPressed: () async {
                  if (state.formValidationStatus.isValidated) {
                    await context.read<NameInputCubit>().postName();

                    var selectedName = state.username;
                    if (isInFlowContext) {
                      context
                          .flow<UserInformation>()
                          .update((s) => s.copyWith(name: selectedName.value));
                    } else {
                      Navigator.pop(context);
                    }
                  }
                },
                text: isInFlowContext ? 'Weiter' : 'Speichern',
              );
      },
    );
  }
}
