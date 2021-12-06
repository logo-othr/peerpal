import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/discover_wizard_flow/discover_wizard_flow.dart';
import 'package:peerpal/home/cubit/home_cubit.dart';
import 'package:peerpal/profile_wizard_flow/pages/profile_wiazrd_flow.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/tabs/discover/discover_tab_bloc.dart';
import 'package:peerpal/tabs/discover/discover_tab_view.dart';
import 'package:peerpal/widgets/custom_tab_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
      HomeCubit(context.read<AppUserRepository>())
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
      child: Container(child: DiscoverTabView()),
    ),
    Center(
      child: Container(),
    ),
    Center(
      child: Container(child: Container()),
    ),
    Center(
      child: Container(child: Container()),
    ),
    Center(
      child: Container(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeUserInformationFlowCompleted) {
            return
              Scaffold(
                bottomNavigationBar: CustomTabBar(index: state.index,

                    onTap: (index) {
                      context.read<HomeCubit>().indexChanged(index);
                    }
                ),
                body: MultiBlocProvider(
                  providers: [
                    BlocProvider<DiscoverTabBloc>(
                      create: (context) =>
                      DiscoverTabBloc(context.read<AppUserRepository>())
                        ..add(UsersLoaded()),
                    ),
                  ],
                  child: tabs[
                  state.index
                  ],
                ),
              );
          } else {
            return Text('TabBar Error');
          }
        }
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
