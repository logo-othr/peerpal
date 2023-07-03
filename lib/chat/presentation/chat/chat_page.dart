import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/domain/usecases/chat_to_userchat_usecase.dart';
import 'package:peerpal/chat/domain/usecases/get_chat_messages_usecase.dart';
import 'package:peerpal/chat/domain/usecases/get_chats_usecase.dart';
import 'package:peerpal/chat/domain/usecases/send_chat_message_usecase.dart';
import 'package:peerpal/chat/domain/usecases/send_chat_request_response_usecase.dart';
import 'package:peerpal/chat/presentation/chat/bloc/chat_page_bloc.dart';
import 'package:peerpal/chat/presentation/chat/chat_page_content.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
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
          getMessagesForChatUseCase:
              GetChatMessagesUseCase(context.read<ChatRepository>()),
          getChatsForUserUseCase: sl<GetChatsUseCase>(),
          appUserRepository: context.read<AppUserRepository>(),
          authenticationRepository: context.read<AuthenticationRepository>(),
          getUserChatForChatUseCase: sl<ChatToUserChatUseCase>(),
          getAuthenticatedUser: sl<GetAuthenticatedUser>(),
          sendMessage: SendChatMessageUseCase(context.read<ChatRepository>()),
          sendChatRequestResponseUseCase:
              SendChatRequestResponseUseCase(context.read<ChatRepository>()),
          chatPartnerId: userId,
        )..add(LoadChatPageEvent(userChat)),
        child: ChatPageContent(),
      ),
    );
  }
}
