import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chatv2/presentation/chatroom/chatroom_content.dart';
import 'package:peerpal/chatv2/presentation/chatroom/chatroom_cubit.dart';
import 'package:peerpal/setup.dart';

class ChatroomPage extends StatelessWidget {
  final String? chatPartnerId;

  const ChatroomPage({required this.chatPartnerId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: BlocProvider<ChatroomCubit>(
        create: (context) => sl<ChatroomCubit>()..loadChatroom(chatPartnerId),
        child: ChatroomContent(),
      ),
    );
  }
}
