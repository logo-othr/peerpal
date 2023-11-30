import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/account_setup/domain/weekly_reminder_usecase.dart';
import 'package:peerpal/account_setup/view/cubit/setup_cubit.dart';
import 'package:peerpal/activity/presentation/activity_feed/activity_feed_page.dart';
import 'package:peerpal/activity/presentation/activity_feed/bloc/activity_feed_bloc.dart';
import 'package:peerpal/app/domain/analytics/analytics_repository.dart';
import 'package:peerpal/chat/presentation/chat_list/cubit/chat_list_cubit.dart';
import 'package:peerpal/chat/presentation/chat_list/view/chat_list_page.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/usecase/find_peers.dart';
import 'package:peerpal/discover_feed/domain/usecase/find_user_by_name.dart';
import 'package:peerpal/discover_feed/presentation/cubit/discover_feed_cubit.dart';
import 'package:peerpal/discover_feed/presentation/view/discover_tab_view.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/friends/domain/repository/friend_repository.dart';
import 'package:peerpal/friends/friends_overview_page/cubit/friends_overview_cubit.dart';
import 'package:peerpal/friends/friends_overview_page/view/friends_overview_page.dart';
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
        child: SettingsPage(
          startRememberMeNotifications: sl<WeeklyReminderUseCase>(),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupCubit, SetupState>(builder: (context, state) {
      if (state is SetupCompletedState) {
        return Scaffold(
          bottomNavigationBar: CustomTabBar(
              index: state.index,
              onTap: (index) {
                context.read<SetupCubit>().indexChanged(index);
              }),
          body: MultiBlocProvider(
            providers: [
              BlocProvider<DiscoverFeedCubit>(
                create: (context) => DiscoverFeedCubit(
                  findPeers: sl<FindPeers>(),
                  findUserByName: sl<FindUserByName>(),
                  analyticsRepository: sl<AnalyticsRepository>(),
                  getAuthenticatedUser: sl<GetAuthenticatedUser>(),
                  appUsersRepository: context.read<AppUserRepository>(),
                )..loadUsers(),
              ),
              BlocProvider<ChatListCubit>(
                create: (context) => sl<ChatListCubit>()..loadChatList(),
              ),
              BlocProvider<ActivityFeedBloc>(
                create: (context) =>
                    sl<ActivityFeedBloc>()..add(LoadActivityFeed()),
              ),
              BlocProvider<FriendsOverviewCubit>(
                create: (context) =>
                FriendsOverviewCubit(sl<FriendRepository>())
                      ..getFriendsFromUser(),
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
