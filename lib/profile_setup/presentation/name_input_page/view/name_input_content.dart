import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/profile_setup/domain/name_input_page/models/username_model.dart';
import 'package:peerpal/profile_setup/presentation/name_input_page/cubit/name_input_cubit.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class NameInputContent extends StatelessWidget {
  final bool isInFlowContext;
  final String pastName;

  const NameInputContent(
      {Key? key, required this.isInFlowContext, required this.pastName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NameInputCubit, NameInputState>(
      listener: _errorFeedbackForSavingName,
      child: _NameInputUi(isInFlowContext: isInFlowContext, pastName: pastName),
    );
  }

  void _errorFeedbackForSavingName(context, state) {
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

class _NameInputUi extends StatelessWidget {
  final isInFlowContext;
  final pastName;

  const _NameInputUi({
    Key? key,
    required this.isInFlowContext,
    required this.pastName,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -1 / 3),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: _UiNameInputContent(
              isInFlowContext: isInFlowContext, pastName: pastName),
        ),
      ),
    );
  }
}

class _UiNameInputContent extends StatelessWidget {
  final isInFlowContext;
  final pastName;

  const _UiNameInputContent({
    Key? key,
    required this.isInFlowContext,
    required this.pastName,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 16.0),
        CustomPeerPALHeading1('Wie ist dein Name?'),
        const SizedBox(height: 120),
        _UsernameInputField(
            isInFlowContext: isInFlowContext, pastName: pastName),
        const SizedBox(height: 190),
        _NextButton(isInFlowContext),
      ],
    );
  }
}

class _UsernameInputField extends StatelessWidget {
  final bool isInFlowContext;
  final String pastName;

  const _UsernameInputField({
    Key? key,
    required this.isInFlowContext,
    required this.pastName,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NameInputCubit, NameInputState>(
      buildWhen: (previous, current) => _hasNameChanged(previous, current),
      builder: (context, state) {
        return FutureBuilder(
          future: context.read<NameInputCubit>().currentName(),
          initialData: pastName,
          builder: (BuildContext context, AsyncSnapshot<String?> text) {
            return TextFormField(
                maxLength: 30,
                initialValue: pastName,
                style: const TextStyle(fontSize: 22),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  helperText: '',
                  errorText: state.username.invalid
                      ? 'Bitte geben sie Ihren Namen ein'
                      : null,
                ),
                key: const Key('name_selection_username_field'),
                onChanged: (username) => _updateUserName(context, username),
                keyboardType: TextInputType.name);
          },
        );
      },
    );
  }

  void _updateUserName(BuildContext context, String username) =>
      context.read<NameInputCubit>().nameChanged(username);

  bool _hasNameChanged(NameInputState previous, NameInputState current) =>
      previous.username != current.username;
}

class _NextButton extends StatelessWidget {
  final bool isInFlowContext;

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
                onPressed: () async {
                  _save(state, context);
                },
                text: isInFlowContext ? 'Weiter' : 'Speichern',
              );
      },
    );
  }

  Future<void> _save(NameInputState state, BuildContext context) async {
    {
      if (state.formValidationStatus.isValidated) {
        await context.read<NameInputCubit>().postName();

        var selectedName = state.username;
        _switchPage(context, selectedName);
      }
    }
  }

  void _switchPage(BuildContext context, UsernameModel selectedName) {
    if (isInFlowContext) {
      context
          .flow<PeerPALUser>()
          .update((s) => s.copyWith(name: selectedName.value));
    } else {
      Navigator.pop(context);
    }
  }
}
