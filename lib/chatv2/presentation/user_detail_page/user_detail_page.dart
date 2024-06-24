import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chatv2/presentation/user_detail_page/cubit/user_detail_cubit.dart';
import 'package:peerpal/chatv2/presentation/user_detail_page/user_detail_content.dart';
import 'package:peerpal/discover_feed_v2/data/repository/app_user_repository.dart';

class UserInformationPage extends StatelessWidget {
  final String userId;
  final bool hasMessageButton;

  const UserInformationPage(this.userId,
      {Key? key, this.hasMessageButton = true})
      : super(key: key);

  static MaterialPage<void> page(String userId) {
    return MaterialPage<void>(child: UserInformationPage(userId));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: BlocProvider<UserDetailCubit>(
        create: (context) => UserDetailCubit(
            appUserRepository: context.read<AppUserRepository>())
          ..loadUser(userId),
        child: UserInformationContent(hasMessageButton: hasMessageButton),
      ),
    );
  }
}
