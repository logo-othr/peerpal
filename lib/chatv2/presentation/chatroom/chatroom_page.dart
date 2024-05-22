import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chatv2/domain/usecases/get_chats.dart';
import 'package:peerpal/chatv2/domain/usecases/get_messages.dart';
import 'package:peerpal/chatv2/domain/usecases/get_user.dart';
import 'package:peerpal/chatv2/presentation/chatroom/chatroom_content.dart';
import 'package:peerpal/chatv2/presentation/chatroom/chatroom_cubit.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';

class ChatroomPage extends StatelessWidget {
  final String? chatId;

  const ChatroomPage({required this.chatId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: BlocProvider<ChatroomCubit>(
        create: (context) => ChatroomCubit(
          getChats: context.read<GetChats>(),
          getAppUser: context.read<GetAuthenticatedUser>(),
          getUser: context.read<GetUser>(),
          getMessages: context.read<GetMessages>(),
        )..loadChatroom(chatId),
        child: ChatroomContent(),
      ),
    );
  }
}
