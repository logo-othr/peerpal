import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:peerpal/discover_feed_v2/domain/peerpal_user.dart';
import 'package:peerpal/profile_setup/domain/name_input_page/models/username_model.dart';
import 'package:peerpal/profile_setup/presentation/name_input_page/cubit/name_input_cubit.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';

class UsernameSubmitButton extends StatelessWidget {
  final bool isInFlowContext;

  UsernameSubmitButton(this.isInFlowContext);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsernameCubit, UsernameState>(
      buildWhen: (previous, current) =>
          previous.formValidationStatus != current.formValidationStatus,
      builder: (context, state) {
        return state.formValidationStatus.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : CustomPeerPALButton(
                onPressed: () async {
                  await _save(state, context);
                  _switchPage(state, context, state.newUsername);
                },
                text: isInFlowContext ? 'Weiter' : 'Speichern',
              );
      },
    );
  }

  Future<void> _save(UsernameState state, BuildContext context) async {
    {
      if (state.formValidationStatus.isValidated) {
        await context.read<UsernameCubit>().postName();
        var selectedName = state.newUsername;
      }
    }
  }

  void _switchPage(
      UsernameState state, BuildContext context, UsernameModel selectedName) {
    if (isInFlowContext && state.formValidationStatus.isValidated) {
      context
          .flow<PeerPALUser>()
          .update((s) => s.copyWith(name: selectedName.value));
    } else {
      Navigator.pop(context);
    }
  }
}
