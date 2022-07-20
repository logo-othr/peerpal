import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chat/presentation/chat_request_list/bloc/chat_request_list_bloc.dart';
import 'package:peerpal/chat/presentation/chat_request_list/chat_request_list_content.dart';
import 'package:peerpal/setup.dart';

class ChatRequestListPage extends StatelessWidget {
  const ChatRequestListPage({Key? key}) : super(key: key);

  static MaterialPage<void> page() {
    return const MaterialPage<void>(child: ChatRequestListPage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider<ChatRequestListBloc>(
        child: ChatRequestListContent(),
        create: (context) =>
            sl<ChatRequestListBloc>()..add(ChatRequestListLoaded()),
      ),
    );
  }
}
