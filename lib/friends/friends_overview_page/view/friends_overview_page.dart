import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/friends/friends_overview_page/cubit/friends_overview_cubit.dart';
import 'package:peerpal/friends/friends_overview_page/view/friends_overview_content.dart';
import 'package:peerpal/repository/app_user_repository.dart';

class FriendsOverviewPage extends StatelessWidget {
  const FriendsOverviewPage({Key? key}) : super(key: key);

  static MaterialPage<void> page() {
    return const MaterialPage<void>(child: FriendsOverviewPage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider(
        create: (_) {
          return FriendsOverviewCubit(context.read<AppUserRepository>())
            ..getFriendsFromUser();
        },
        child: FriendsOverviewContent(),
      ),
    );
  }
}
