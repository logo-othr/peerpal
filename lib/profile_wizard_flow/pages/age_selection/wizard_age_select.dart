import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/profile_wizard_flow/models/profile.dart';
import 'package:peerpal/profile_wizard_flow/pages/age_selection/age_selection_cubit.dart';
import 'package:peerpal/profile_wizard_flow/repository/profile_wizard_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:peerpal/profile_wizard_flow/repository/user_repository.dart';
import 'package:peerpal/widgets/age_picker.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class AgeSelection extends StatelessWidget {
  static MaterialPage<void> page() {
    return MaterialPage<void>(child: AgeSelection());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        // ToDo: Update repository and get it with getit
        return AgeSelectionCubit(FakeUserRepository());
      },
      child: AgeSelectionForm(),
    );
  }
}

class AgeSelectionForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.flow<Profile>().complete(),
        ),
        title: const Text('Country'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<AgeSelectionCubit, AgeSelectionState>(
                builder: (context, state) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      CustomPeerPALHeading1("Willkommen bei PeerPAL"),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        //   decoration: peerpalLogo,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      CustomPeerPALHeading1("Wie alt bist du?"),
                      AgePicker(
                        hint: const Text('Alter auswählen'),
                        items: state.ages.map((el) => el.toString()).toList(),
                        value: state.selectedAge,
                        onChanged: (value) =>
                            context.read<AgeSelectionCubit>().ageSelected(
                                  (state.ages[value!]),
                                ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            Spacer(),
            BlocBuilder<AgeSelectionCubit, AgeSelectionState>(
              builder: (context, state) {
                if (state is AgeSelectionPosting) {
                  return CircularProgressIndicator();
                } else {
                  return CustomPeerPALButton(
                    text: "Weiter",
                    onPressed: () async {
                      await context
                          .read<AgeSelectionCubit>()
                          .postAge(state.selectedAge);
                      context
                          .flow<Profile>()
                          .update((s) => s.copyWith(age: state.selectedAge));
                      print(context
                          .flow<Profile>().state.age);
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
