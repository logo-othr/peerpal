import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/bloc/app_bloc.dart';
import 'package:peerpal/discover_wizard_flow/discover_wizard_flow.dart';
import 'package:peerpal/home/cubit/home_cubit.dart';
import 'package:peerpal/profile_wizard_flow/pages/profile_wiazrd_flow.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/widgets/custom_tab_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(context.read<AppUserRepository>())..loadFlowState(),
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
        if(state is HomeProfileFlow) {
          await Navigator.of(context).push(
            ProfileWizardFlow.route(state.userInformation),
          );
          await BlocProvider.of<HomeCubit>(context).loadFlowState();
        }
        if(state is HomeDiscoverFlow) {
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
              child: Text("Nicht geladen"),
            );
          }),
    );
  }
}

class MyTabView extends StatelessWidget {
  MyTabView({Key? key}) : super(key: key);

  static MaterialPage<void> page() {
    return MaterialPage<void>(child: MyTabView());
  }

  final tabs = [
    Center(
      child: Container(child: DiscoverTabPage()),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PeerPAL'),
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.read<AppBloc>().add(AppLogoutRequested()),
          )
        ],
      ),
      bottomNavigationBar: CustomTabBar(),
      body: tabs[0],
    );
  }
}

class DiscoverTabPage extends StatelessWidget {
  const DiscoverTabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
