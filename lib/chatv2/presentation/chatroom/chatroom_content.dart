import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chat/presentation/chat/widgets/chat_message_input_field.dart';
import 'package:peerpal/chat/presentation/user_detail_page/user_detail_page.dart';
import 'package:peerpal/chatv2/domain/enums/message_type.dart';
import 'package:peerpal/chatv2/presentation/chatroom/chatroom_cubit.dart';
import 'package:peerpal/chatv2/presentation/widgets/chat_buttons.dart';
import 'package:peerpal/chatv2/presentation/widgets/chat_header.dart';
import 'package:peerpal/chatv2/presentation/widgets/message_list.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';

class ChatroomContent extends StatelessWidget {
  ChatroomContent({
    Key? key,
  }) : super(key: key);
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  Widget build(BuildContext chatroomContext) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ChatroomCubit, ChatroomState>(
            builder: (context, chatroomState) {
          if (chatroomState is ChatroomInitial) {
            return _chatroomInitial();
          } else if (chatroomState is ChatroomLoading) {
            return _chatroomLoading(chatroomState, chatroomContext);
          } else if (chatroomState is ChatroomUninitialized) {
            return _chatroomUninitialized(chatroomState, chatroomContext);
          } else if (chatroomState is ChatroomLoaded) {
            return _chatroomLoaded(chatroomState, chatroomContext);
          } else
            return Placeholder();
        }),
      ),
    );
  }

  Widget _chatroomInitial() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _chatroomLoading(ChatroomLoading state, BuildContext roomCtx) {
    print(state.runtimeType);
    return Column(
      children: [
        ChatHeader(
          chatPartner: state.chatPartner,
          onBackButtonPressed: () => Navigator.of(roomCtx).pop(),
          onBarPressed: () => _openUserpage(roomCtx, state.chatPartner.id!),
        ),
      ],
    );
  }

  void _openUserpage(BuildContext chatroomContext, String userId) {
    Navigator.push(
      chatroomContext,
      MaterialPageRoute(
        builder: (context) => UserInformationPage(
          userId,
          hasMessageButton: false,
        ),
      ),
    );
  }

  Widget _chatroomUninitialized(
      ChatroomUninitialized state, BuildContext roomCtx) {
    return Column(
      children: [
        ChatHeader(
          chatPartner: state.chatPartner,
          onBackButtonPressed: () => Navigator.of(roomCtx).pop(),
          onBarPressed: () => _openUserpage(roomCtx, state.chatPartner.id!),
        ),
        Center(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Text(
              "Schreibe eine Nachricht, um ${state.chatPartner.name} eine Chat-Anfrage zu schicken"),
        )),
        Spacer(),
        _chatRequestResponsePanel(roomCtx),
      ],
    );
  }

  Widget _chatroomLoaded(ChatroomLoaded loadedState, BuildContext roomCtx) {
    ChatroomCubit cubit = roomCtx.read<ChatroomCubit>();
    bool isChatRequest = cubit.isChatRequest();
    return Column(
      children: [
        ChatHeader(
          chatPartner: loadedState.chatPartner,
          onBackButtonPressed: () => Navigator.of(roomCtx).pop(),
          onBarPressed: () =>
              _openUserpage(roomCtx, loadedState.chatPartner.id!),
        ),
        MessageList(
          appUser: loadedState.appUser,
          messages: loadedState.messages,
        ),
        isChatRequest
            ? _chatRequestResponsePanel(roomCtx)
            : _chatMessagePanel(roomCtx),
      ],
    );
  }

  Widget _chatRequestResponsePanel(BuildContext roomCtx) {
    ChatroomCubit cubit = roomCtx.read<ChatroomCubit>();
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
      child: Container(
        child: Column(
          children: [
            CustomPeerPALButton(
                text: "Annehmen",
                onPressed: () {
                  cubit.sendChatRequestResponse(true);
                  Navigator.pop(roomCtx);
                }),
            SizedBox(height: 8),
            CustomPeerPALButton(
                text: "Ablehnen",
                onPressed: () {
                  cubit.sendChatRequestResponse(false);
                  Navigator.pop(roomCtx);
                }),
          ],
        ),
      ),
    );
  }

  Widget _chatMessagePanel(BuildContext roomCtx) {
    ChatroomCubit cubit = roomCtx.read<ChatroomCubit>();

    return Column(
      children: [
        ChatButtons(cubit.state.appUser.phoneNumber,
            textEditingController: _textEditingController),
        ChatMessageInputField(
          textEditingController: _textEditingController,
          focus: _focus,
          sendTextMessage: () =>
              cubit.sendMessage(_textEditingController.text, MessageType.text),
          sendImageMessage: () =>
              cubit.sendMessage(_textEditingController.text, MessageType.image),
        )
      ],
    );
  }
}

class ChatRequestResponsePanel extends StatelessWidget {
  final Future<void> Function(bool acceptResponse) onSendChatRequestResponse;

  const ChatRequestResponsePanel(
      {required this.onSendChatRequestResponse, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
      child: Container(
        child: Column(
          children: [
            CustomPeerPALButton(
                text: "Annehmen",
                onPressed: () async {
                  await onSendChatRequestResponse(true);
                  Navigator.pop(context);
                }),
            SizedBox(height: 8),
            CustomPeerPALButton(
                text: "Ablehnen",
                onPressed: () async {
                  await onSendChatRequestResponse(false);
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
