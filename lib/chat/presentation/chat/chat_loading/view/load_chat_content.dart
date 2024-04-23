import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chat/domain/usecases/send_chat_message_usecase.dart';
import 'package:peerpal/chat/presentation/chat/chat_loaded/chat_loaded.dart';
import 'package:peerpal/chat/presentation/chat/chat_loaded/chat_loaded_cubit.dart';
import 'package:peerpal/chat/presentation/chat/chat_loading/cubit/chat_page_cubit.dart';
import 'package:peerpal/chat/presentation/chat/new_chat/view/new_chat.dart';
import 'package:peerpal/setup.dart';

class LoadChatContent extends StatelessWidget {
  LoadChatContent({
    Key? key,
  }) : super(key: key);
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ChatPageCubit, ChatPageState>(
            builder: (context, chatPageState) {
          if (chatPageState is ChatPageInitial ||
              chatPageState is ChatLoadingState) {
            return CircularProgressIndicator();
          } else if (chatPageState is ChatLoadedState) {
            return BlocProvider(
              create: (context) => ChatLoadedCubit(
                chatLoadedState: chatPageState,
                sendMessage: sl<SendChatMessageUseCase>(),
              ),
              child: ChatLoaded(
                focus: _focus,
                textEditingController: _textEditingController,
              ),
            );
          } else if (chatPageState is NewChatState) {
            return NewChat(
              state: chatPageState,
              focusNode: _focus,
              textEditingController: _textEditingController,
            );
          } else {
            return CircularProgressIndicator();
          }
        }),
      ),
    );
  }
}
