import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/profile_wizard_flow/pages/age_input_page/cubit/age_input_cubit.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';
import 'package:peerpal/widgets/age_picker.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/peerpal_complete_page_button.dart';

class AgeInputContent extends StatelessWidget {
  final bool isInFlowContext;

  AgeInputContent({Key? key, required this.isInFlowContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var hasBackButton = (isInFlowContext) ? false : true;
    return Scaffold(
        appBar: CustomAppBar(
          "Alter",
          hasBackButton: hasBackButton,
        ),
        body: BlocBuilder<AgeInputCubit, AgeInputState>(
            builder: (context, state) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 40,
                        ),
                        CustomPeerPALHeading1('Willkommen bei PeerPAL'),
                        const SizedBox(
                          height: 40,
                        ),
                        const SizedBox(
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        CustomPeerPALHeading1('Wie alt bist du?'),
                        AgePicker(
                          hint: const Text('Alter auswählen'),
                          items: state.ages.map((el) => el.toString()).toList(),
                          value: state.selectedAge,
                          onChanged: (value) =>
                              context.read<AgeInputCubit>().dataChanged(
                                    (state.ages[value!]),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                (state is AgeInputPosting)
                    ? const CircularProgressIndicator()
                    : CompletePageButton(
                        isSaveButton: isInFlowContext,
                        onPressed: () async {
                          _update(state, context);
                        }),
              ],
            ),
          );
        }));
  }

  Future<void> _update(AgeInputState state, BuildContext context) async {
    if (isInFlowContext) {
      await context.read<AgeInputCubit>().postData();
      context
          .flow<PeerPALUser>()
          .complete((s) => s.copyWith(age: state.selectedAge));
    } else {
      await context.read<AgeInputCubit>().postData();
      Navigator.pop(context);
    }
  }
}
