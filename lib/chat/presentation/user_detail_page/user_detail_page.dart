import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chat/presentation/user_detail_page/bloc/user_detail_bloc.dart';
import 'package:peerpal/chat/presentation/user_detail_page/user_detail_content.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';

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
      child: BlocProvider<UserDetailBloc>(
        create: (context) =>
            UserDetailBloc(userId, context.read<AppUserRepository>())
              ..add(LoadUserDetail()),
        child: UserInformationContent(hasMessageButton: hasMessageButton),
      ),
    );
  }
}
