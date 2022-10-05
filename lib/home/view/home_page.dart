import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app_tab_view/presentation/view/tabview.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_setup/discover_wizard_flow.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/home/cubit/home_cubit.dart';
import 'package:peerpal/profile_setup/profile_wiazrd_flow.dart';
import 'package:peerpal/setup.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: SetupPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(
          context.read<AppUserRepository>(), sl<GetAuthenticatedUser>())
        ..loadCurrentSetupFlowState(),
      child: const SetupPageContent(),
    );
  }
}

class SetupPageContent extends StatelessWidget {
  const SetupPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) async {
        if (state is ProfileSetupState) {
          await loadProfileSetup(context, state);
        }
        if (state is DiscoverSetupState) {
          await loadDiscoverSetup(context, state);
        }
      },
      child: BlocBuilder<HomeCubit, HomeState>(
          bloc: BlocProvider.of<HomeCubit>(context),
          builder: (context, state) {
            if (state is SetupCompletedState) {
              return AppTabView();
            }
            return _LoadingIndicator();
          }),
    );
  }

  Future<void> loadProfileSetup(
      BuildContext context, ProfileSetupState state) async {
    await Navigator.of(context).push(
      ProfileSetupFlow.route(state.userInformation),
    );
    await BlocProvider.of<HomeCubit>(context).loadCurrentSetupFlowState();
  }

  Future<void> loadDiscoverSetup(
      BuildContext context, DiscoverSetupState state) async {
    await Navigator.of(context).push(
      DiscoverSetupFlow.route(state.userInformation),
    );
    BlocProvider.of<HomeCubit>(context).loadCurrentSetupFlowState();
  }

  Widget _LoadingIndicator() {
    return Container(
      child: Container(
        child: Scaffold(
            appBar: CustomAppBar(
              "PeerPAL",
              hasBackButton: false,
            ),
            body: Center(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                    child: Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                          const SizedBox(height: 300),
                          CustomPeerPALHeading1("Laden..."),
                          CircularProgressIndicator(),
                        ]))))),
      ),
    );
  }
}
