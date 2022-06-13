import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activities/activity_feed/activity_feed_page.dart';
import 'package:peerpal/chat/presentation/chat_list/bloc/chat_list_bloc.dart';
import 'package:peerpal/chat/presentation/chat_list/chat_list_page.dart';
import 'package:peerpal/discover/discover_tab_bloc.dart';
import 'package:peerpal/discover/discover_tab_view.dart';
import 'package:peerpal/discover_setup/discover_wizard_flow.dart';
import 'package:peerpal/friends/friends_overview_page/view/friends_overview_page.dart';
import 'package:peerpal/home/cubit/home_cubit.dart';
import 'package:peerpal/injection.dart';
import 'package:peerpal/login_flow/persistence/authentication_repository.dart';
import 'package:peerpal/profile_setup/pages/profile_wiazrd_flow.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/get_user_usecase.dart';
import 'package:peerpal/settings/settings_page.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/custom_tab_bar.dart';

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
              context.read<AuthenticationRepository>().registerFCMDeviceToken();
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

class MyTabView extends StatelessWidget {
  MyTabView({Key? key}) : super(key: key);

  static MaterialPage<void> page() {
    return MaterialPage<void>(child: MyTabView());
  }

  final tabs = [
    Center(
      child: ActivityFeedPage(),
    ),
    Center(
      child: Container(child: DiscoverTabView()),
    ),
    Center(
      child: Container(child: FriendsOverviewPage()),
    ),
    Center(
      child: Container(child: ChatListPage()),
    ),
    Center(
      child: Container(
        child: SettingsPage(),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      if (state is HomeUserInformationFlowCompleted) {
        return Scaffold(
          bottomNavigationBar: CustomTabBar(
              index: state.index,
              onTap: (index) {
                context.read<HomeCubit>().indexChanged(index);
              }),
          body: MultiBlocProvider(
            providers: [
              BlocProvider<DiscoverTabBloc>(
                create: (context) => DiscoverTabBloc(
                    context.read<AppUserRepository>(),
                    context.read<AuthenticationRepository>())
                  ..add(UsersLoaded()),
              ),
              BlocProvider<ChatListBloc>(
                create: (context) => sl<ChatListBloc>()..add(ChatListLoaded()),
              ),
            ],
            child: tabs[state.index],
          ),
        );
      } else {
        return Text('TabBar Error');
      }
    });
  }
}

class DiscoverTabPage extends StatelessWidget {
  const DiscoverTabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
