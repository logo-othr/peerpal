import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/discover_feed_v2/domain/peerpal_user.dart';
import 'package:peerpal/profile_setup/presentation/age_input_page/cubit/age_input_cubit.dart';
import 'package:peerpal/widgets/peerpal_complete_page_button.dart';

class SubmitAgeButton extends StatelessWidget {
  final AgeInputState state;
  final bool isInFlowContext;
  final BuildContext pageContext;

  const SubmitAgeButton(
      {required this.pageContext,
      required this.state,
      required this.isInFlowContext,
      Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
      child: CompletePageButton(
          isSaveButton: isInFlowContext,
          onPressed: () async {
            await _update(state, pageContext, isInFlowContext);
          }),
    );
  }

  Future<void> _update(AgeInputState state, BuildContext pageContext,
      bool isInFlowContext) async {
    if (isInFlowContext) {
      await pageContext.read<AgeInputCubit>().update();
      pageContext
          .flow<PeerPALUser>()
          .update((s) => s.copyWith(age: state.selectedAge));
    } else {
      await pageContext.read<AgeInputCubit>().update();
      Navigator.pop(pageContext);
    }
  }
}
