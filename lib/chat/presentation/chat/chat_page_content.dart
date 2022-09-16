import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chat/presentation/chat/bloc/chat_page_bloc.dart';
import 'package:peerpal/chat/presentation/chat/view/chat_loaded_content.dart';
import 'package:peerpal/chat/presentation/chat/view/chat_loading_content.dart';
import 'package:peerpal/chat/presentation/chat/view/chat_waiting_for_chat_or_first_message_content.dart';

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
            BlocBuilder<ChatPageBloc, ChatPageState>(builder: (context, state) {
          if (state is ChatPageInitial) {
            return CircularProgressIndicator();
          } else if (state is ChatLoadingState) {
            return ChatLoadingContent(state: state);
          } else if (state is ChatLoadedState) {
            return ChatLoadedContent(
              state: state,
              focus: _focus,
              textEditingController: _textEditingController,
            );
          } else if (state is WaitingForChatOrFirstMessage) {
            return WaitingForChatOrFirstMessageContent(
              state: state,
              focusNode: _focus,
              textEditingController: _textEditingController,
            );
          } else if (state is ChatPageError) {
            return _chatContentError(state);
          } else {
            return CircularProgressIndicator();
          }
        }),
      ),
    );
  }

  void _setupListener() {
    _focus.addListener(() {
      print("Focus: ${_focus.hasFocus.toString()}");
    });
  }

  Widget _chatContentError(ChatPageError state) {
    return Container(
      child: Center(
        child: Text(state.message),
      ),
    );
  }
}
