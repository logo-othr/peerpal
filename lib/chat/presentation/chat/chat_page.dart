import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/domain/usecases/get_chats_for_users.dart';
import 'package:peerpal/chat/domain/usecases/get_messages_for_chat.dart';
import 'package:peerpal/chat/domain/usecases/get_userchat_for_chat.dart';
import 'package:peerpal/chat/domain/usecases/send_chat_message.dart';
import 'package:peerpal/chat/domain/usecases/send_chat_request_response.dart';
import 'package:peerpal/chat/presentation/chat/bloc/chat_page_bloc.dart';
import 'package:peerpal/chat/presentation/chat/chat_page_content.dart';
import 'package:peerpal/peerpal_user/data/repository/app_user_repository.dart';
import 'package:peerpal/peerpal_user/domain/usecase/get_user_usecase.dart';
import 'package:peerpal/setup.dart';

class ChatPage extends StatelessWidget {
  final String userId;
  final UserChat? userChat;

  const ChatPage({required this.userId, this.userChat, Key? key})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: BlocProvider<ChatPageBloc>(
        create: (context) => ChatPageBloc(
          getMessagesForChat:
              GetMessagesForChat(context.read<ChatRepository>()),
          getChatsForUser: sl<GetChatsForUser>(),
          appUserRepository: context.read<AppUserRepository>(),
          authenticationRepository: context.read<AuthenticationRepository>(),
          getUserChatForChat: sl<GetUserChatForChat>(),
          getAuthenticatedUser: sl<GetAuthenticatedUser>(),
          sendMessage: SendChatMessage(context.read<ChatRepository>()),
          sendChatRequestResponse:
              SendChatRequestResponse(context.read<ChatRepository>()),
          chatPartnerId: userId,
        )..add(LoadChatPageEvent(userChat)),
        child: ChatPageContent(),
      ),
    );
  }
}
