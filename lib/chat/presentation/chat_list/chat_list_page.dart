
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecases/get_chats_for_users.dart';
import 'package:peerpal/chat/presentation/chat_list/chat_list_content.dart';
import 'package:peerpal/repository/app_user_repository.dart';

import 'bloc/chat_list_bloc.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  static MaterialPage<void> page() {
    return const MaterialPage<void>(child: ChatListPage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ChatListContent(),
    );
  }
}
