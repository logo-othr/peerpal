import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/discover_setup/discover_wizard_flow.dart';
import 'package:peerpal/home/cubit/home_cubit.dart';
import 'package:peerpal/peerpal_user/data/repository/app_user_repository.dart';
import 'package:peerpal/peerpal_user/domain/usecase/get_user_usecase.dart';
import 'package:peerpal/profile_setup/profile_wiazrd_flow.dart';
import 'package:peerpal/setup.dart';
import 'package:peerpal/tabview/presentation/view/tabview.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(
          context.read<AppUserRepository>(), sl<GetAuthenticatedUser>())
        ..loadFlowState(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Build method called");
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) async {
        if (state is HomeProfileFlow) {
          await Navigator.of(context).push(
            ProfileWizardFlow.route(state.userInformation),
          );
          await BlocProvider.of<HomeCubit>(context).loadFlowState();
        }
        if (state is HomeDiscoverFlow) {
          await Navigator.of(context).push(
            DiscoverWizardFlow.route(state.userInformation),
          );
          BlocProvider.of<HomeCubit>(context).loadFlowState();
        }
      },
      child: BlocBuilder<HomeCubit, HomeState>(
          bloc: BlocProvider.of<HomeCubit>(context),
          builder: (context, state) {
            if (state is HomeUserInformationFlowCompleted) {
              return MyTabView();
            }
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
          }),
    );
  }
}
