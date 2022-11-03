import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activity/presentation/activity_feed/activity_feed_page.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/presentation/chat_list/bloc/chat_list_bloc.dart';
import 'package:peerpal/chat/presentation/chat_list/chat_list_page.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/presentation/bloc/discover_feed_bloc.dart';
import 'package:peerpal/discover_feed/presentation/view/discover_tab_view.dart';
import 'package:peerpal/friends/friends_overview_page/view/friends_overview_page.dart';
import 'package:peerpal/home/cubit/home_cubit.dart';
import 'package:peerpal/settings/settings_page.dart';
import 'package:peerpal/setup.dart';
import 'package:peerpal/widgets/custom_tab_bar.dart';

class AppTabView extends StatefulWidget {
  final int initialTabIndex;

  const AppTabView({Key? key, this.initialTabIndex = 0}) : super(key: key);

  static MaterialPage<void> page() {
    return MaterialPage<void>(child: AppTabView());
  }

  @override
  State<AppTabView> createState() => _AppTabViewState();
}

class _AppTabViewState extends State<AppTabView> {
  @override
  void initState() {
    super.initState();
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
      if (state is SetupCompletedState) {
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
                  ..add(LoadUsers()),
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
