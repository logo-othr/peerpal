import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chat/presentation/chat/chat_loaded/chat_loaded.dart';
import 'package:peerpal/chat/presentation/chat/chat_loaded/chat_loaded_cubit.dart';
import 'package:peerpal/chat/presentation/chat/chat_page/cubit/chat_page_cubit.dart';
import 'package:peerpal/chat/presentation/chat/new_chat/view/new_chat.dart';
import 'package:peerpal/setup.dart';

class ChatPageContent extends StatelessWidget {
  ChatPageContent({
    Key? key,
  }) : super(key: key);
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ChatPageCubit, ChatPageState>(
            builder: (context, state) {
          if (state is ChatPageInitial || state is ChatLoadingState) {
            return CircularProgressIndicator();
          } else if (state is ChatLoadedState) {
            return BlocProvider(
              create: (context) => sl<ChatLoadedCubit>(),
              child: ChatLoaded(
                state: state,
                focus: _focus,
                textEditingController: _textEditingController,
              ),
            );
          } else if (state is NewChatState) {
            return NewChat(
              state: state,
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
