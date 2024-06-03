import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chatv2/presentation/chat_request_list/chat_request_list_content.dart';
import 'package:peerpal/chatv2/presentation/chat_request_list/cubit/chat_requests_cubit.dart';
import 'package:peerpal/setup.dart';

class ChatRequestListPage extends StatelessWidget {
  const ChatRequestListPage({Key? key}) : super(key: key);

  static MaterialPage<void> page() {
    return const MaterialPage<void>(child: ChatRequestListPage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => true,
        child: BlocProvider.value(
            value: sl<ChatRequestsCubit>()..loadChatRequests(),
            child: ChatRequestListContent()));
  }
}
