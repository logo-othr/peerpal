import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/domain/usecases/get_all_userchats.dart';
import 'package:peerpal/chat/presentation/chat/chat_loading/cubit/chat_page_cubit.dart';
import 'package:peerpal/chat/presentation/chat/chat_loading/view/load_chat_content.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/setup.dart';

class LoadChatPage extends StatelessWidget {
  final String userId;
  final UserChat? userChat;

  const LoadChatPage({required this.userId, this.userChat, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: BlocProvider<ChatPageCubit>(
        create: (context) => ChatPageCubit(
            appUserRepository: sl<AppUserRepository>(),
            chatRepository: sl<ChatRepository>(),
            getAuthenticatedUser: sl<GetAuthenticatedUser>(),
            getAllUserChats: sl<GetAllUserChats>(),
            chatPartnerId: userId)
          ..loadChat(),
        child: LoadChatContent(),
      ),
    );
  }
}
