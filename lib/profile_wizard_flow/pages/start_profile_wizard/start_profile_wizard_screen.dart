import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/profile_wizard_flow/models/profile.dart';
import 'package:peerpal/profile_wizard_flow/pages/start_profile_wizard/start_profile_wizard_cubit.dart';
import 'package:peerpal/profile_wizard_flow/repository/user_repository.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:flow_builder/flow_builder.dart';

class ProfileWizardScreen extends StatelessWidget {
  const ProfileWizardScreen({Key? key}) : super(key: key);

  static MaterialPage<void> page() {
    return MaterialPage<void>(
        child: BlocProvider(
          create: (context) => StartProfileWizardCubit(FakeUserRepository())..getProfile(),
      child: ProfileWizardScreen(),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Assistent Start"),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: BlocConsumer<StartProfileWizardCubit, ProfileWizardState>(
          listener: (context, state) {
            if(state is ProfileWizardError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 1),
              ));
            }
            if(state is ProfileWizardLoaded) {
              context.flow<Profile>().update(
                      (s) => s.copyWith(age: state.profile.age));
            }
          },
          builder: (context, state) {
            if (state is ProfileWizardInitial) {
              return Text("Initial");
            } else if (state is ProfileWizardLoading) {
              return Text("Loading...");
            } else if (state is ProfileWizardLoaded) {
              return Text("Daten...");
            } else {
              return Text("Initial...");
            }
          },
        ),
      ),
    );
  }
}
