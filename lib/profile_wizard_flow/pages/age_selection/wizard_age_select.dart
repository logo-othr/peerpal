import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/profile_wizard_flow/pages/age_selection/age_selection_cubit.dart';
import 'package:peerpal/repository/auth_repository.dart';
import 'package:peerpal/repository/models/app_user.dart';
import 'package:peerpal/widgets/age_picker.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class AgeSelection extends StatelessWidget {
  static MaterialPage<void> page() {
    return MaterialPage<void>(child: AgeSelection());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider(
        create: (_) {
          return AgeSelectionCubit(context.read<AuthenticationRepository>());
        },
        child: AgeSelectionForm(),
      ),
    );
  }
}

class AgeSelectionForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const Text('Alter'),
        centerTitle: true,
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

                      int selectedAge = state.selectedAge;
                      context
                          .flow<AppUser>()
                          .update((s) => s.copyWith(age: selectedAge));
                      AppUser appUser = context.flow<AppUser>().state;
                      print(appUser.age);
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
