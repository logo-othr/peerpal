import 'package:flutter/material.dart';
import 'package:peerpal/chat/presentation/chatlist/view/chat_list_content.dart';

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
