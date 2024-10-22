import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/friends/domain/repository/friend_repository.dart';
import 'package:peerpal/friends/friend_request_page/cubit/friend_requests_cubit.dart';
import 'package:peerpal/friends/friend_request_page/view/friend_requests_content.dart';
import 'package:peerpal/setup.dart';

class FriendRequestsPage extends StatelessWidget {
  const FriendRequestsPage({Key? key}) : super(key: key);

  static MaterialPage<void> page() {
    return const MaterialPage<void>(child: FriendRequestsPage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: BlocProvider(
        create: (_) {
          return FriendRequestsCubit(
              context.read<AppUserRepository>(), sl<FriendRepository>())
            ..getFriendRequestsFromUser();
        },
        child: FriendRequestsContent(),
      ),
    );
  }
}
