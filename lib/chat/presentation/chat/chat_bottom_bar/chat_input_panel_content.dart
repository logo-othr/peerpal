import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chat/domain/models/user_chat.dart';
import 'package:peerpal/chat/presentation/chat/chat_bottom_bar/cubit/chat_input_panel_cubit.dart';
import 'package:peerpal/chat/presentation/chat/widgets/chat_message_input_field.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/widgets/chat_buttons.dart';
import 'package:peerpal/widgets/custom_loading_indicator.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';

class ChatInputPanelContent extends StatefulWidget {
  final String currentUserId;
  final UserChat userChat;
  final PeerPALUser appUser;
  final PeerPALUser chatPartner;
  final TextEditingController chatMessageController;
  final ChatMessageInputField chatMessageInputField;

  const ChatInputPanelContent(
      {required this.currentUserId,
      required this.userChat,
      required this.appUser,
      required this.chatPartner,
      required this.chatMessageController,
      required this.chatMessageInputField,
      Key? key})
      : super(key: key);

  @override
  State<ChatInputPanelContent> createState() => _ChatInputPanelContentState();
}

class _ChatInputPanelContentState extends State<ChatInputPanelContent> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatInputPanelCubit, ChatInputPanelState>(
      builder: (context, state) {
        if (state is ChatInputPanelLoadingState) {
          return CustomLoadingIndicator(text: "Chat wird geladen..");
        } else if (state is ChatInputPanelLoadedState) {
          if (state.isChatRequestNotAccepted &&
              state.isChatNotStartedByAppUser) {
            return _chatRequestReplyButtons(context);
          } else if (state.messageCount == 0) {
            return _chatDoesNotExist();
          } else {
            return _bottomBarContent();
          }
        } else if (state is ChatInputPanelErrorState) {
          return Text('Error: ${state.errorMessage}');
        } else {
          return Container(); // fallback if none of the above states match
        }
      },
    );
  }


  bool get isChatNotStartedByAppUser =>
      widget.userChat.chat.startedBy != widget.appUser.id;

  bool get isChatRequestNotAccepted =>
      !widget.userChat.chat.chatRequestAccepted;

  Widget _bottomBarContent() {
    return Column(
      children: [
        ChatButtons(widget.appUser.phoneNumber,
            textEditingController: widget.chatMessageController),
        widget.chatMessageInputField,
      ],
    );
  }

  Widget _chatDoesNotExist() {
    return Container(
      width: double.infinity,
      height: 500,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Der Chat ist nicht mehr vorhanden."),
          SizedBox(
            height: 50,
          ),
          CustomPeerPALButton(
            text: "Zurück",
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  Widget _chatRequestReplyButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
      child: Container(
        child: Column(
          children: [
            CustomPeerPALButton(
                text: "Annehmen",
                onPressed: () {
                  context
                      .read<ChatInputPanelCubit>()
                      .sendChatRequestResponse(true);
                  Navigator.pop(context);
                }),
            SizedBox(height: 8),
            CustomPeerPALButton(
                text: "Ablehnen",
                onPressed: () {
                  context
                      .read<ChatInputPanelCubit>()
                      .sendChatRequestResponse(false);
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
