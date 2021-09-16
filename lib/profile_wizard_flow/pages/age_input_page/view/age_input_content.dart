import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/bloc/app_bloc.dart';
import 'package:peerpal/profile_wizard_flow/pages/age_input_page/cubit/age_input_cubit.dart';
import 'package:peerpal/repository/models/user_information.dart';
import 'package:peerpal/widgets/age_picker.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class AgeInputContent extends StatelessWidget {
  final bool isInFlowContext;

  AgeInputContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var hasBackButton = (isInFlowContext)? false : true;
    return Scaffold(
      appBar: CustomAppBar("Alter", hasBackButton: hasBackButton, ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<AgeInputCubit, AgeInputState>(
                builder: (context, state) {
              return Center(
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
                            context.read<AgeInputCubit>().ageChanged(
                                  (state.ages[value!]),
                                ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const Spacer(),
            BlocBuilder<AgeInputCubit, AgeInputState>(
              builder: (context, state) {
                if (state is AgeInputPosting) {
                  return const CircularProgressIndicator();
                } else {
                  if(isInFlowContext) {
                    return CustomPeerPALButton(
                      text: 'Weiter',
                      onPressed: () async {
                        await context
                            .read<AgeInputCubit>()
                            .postAge(state.selectedAge);

                        var selectedAge = state.selectedAge;
                        context
                            .flow<UserInformation>()
                            .update((s) => s.copyWith(age: selectedAge));
                      },
                    );
                  } else {
                    return CustomPeerPALButton(
                      text: 'Speichern',
                      onPressed: () async {
                        await context
                            .read<AgeInputCubit>()
                            .postAge(state.selectedAge);
                        Navigator.pop(context);
                      },
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
