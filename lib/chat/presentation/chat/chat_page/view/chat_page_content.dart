import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app_logger.dart';
import 'package:peerpal/chat/presentation/chat/chat_loaded/chat_loaded.dart';
import 'package:peerpal/chat/presentation/chat/chat_loaded/chat_loaded_cubit.dart';
import 'package:peerpal/chat/presentation/chat/chat_page/cubit/chat_page_cubit.dart';
import 'package:peerpal/chat/presentation/chat/widgets/chat_waiting_for_first_message.dart';
import 'package:peerpal/setup.dart';

class ChatPageContent extends StatelessWidget {
  ChatPageContent({
    Key? key,
  }) : super(key: key);
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    _setupListener();
    return Scaffold(
      body: SafeArea(
        child:
        BlocBuilder<ChatPageCubit, ChatPageState>(
            builder: (context, state) {
          if (state is ChatPageInitial) {
            return CircularProgressIndicator();
          } else if (state is ChatLoadingState) {
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
            return WaitingForFirstMessage(
              state: state,
              focusNode: _focus,
              textEditingController: _textEditingController,
            );
          }
          /* else if (state is ChatPageError) {
            return _chatContentError(state);
          }*/
          else {
            return CircularProgressIndicator();
          }
        }),
      ),
    );
  }

  void _setupListener() {
    _focus.addListener(() {
      logger.i("Focus: ${_focus.hasFocus.toString()}");
    });
  }

/*Widget _chatContentError(ChatPageError state) {
    return Container(
      child: Center(
        child: Text(state.message),
      ),
    );
  }*/
}
