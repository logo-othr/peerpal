import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chat/domain/models/user_chat.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/presentation/chat/chat_bottom_bar/chat_input_panel_content.dart';
import 'package:peerpal/chat/presentation/chat/chat_bottom_bar/cubit/chat_input_panel_cubit.dart';
import 'package:peerpal/chat/presentation/chat/widgets/chat_message_input_field.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/setup.dart';

class ChatInputPanel extends StatelessWidget {
  final String currentUserId;
  final UserChat userChat;
  final PeerPALUser appUser;
  final PeerPALUser chatPartner;
  final TextEditingController chatMessageController;
  final ChatMessageInputField chatMessageInputField;

  const ChatInputPanel(
      {required this.currentUserId,
      required this.userChat,
      required this.appUser,
      required this.chatPartner,
      required this.chatMessageController,
      required this.chatMessageInputField,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatInputPanelCubit>(
      create: (context) => ChatInputPanelCubit(
          chatRepository: sl<ChatRepository>(),
          currentUserId: currentUserId,
          userChat: userChat,
          appUser: appUser,
          chatPartner: chatPartner)
        ..loadChat(),
      child: ChatInputPanelContent(
        chatPartner: chatPartner,
        currentUserId: currentUserId,
        userChat: userChat,
        appUser: appUser,
        chatMessageController: chatMessageController,
        chatMessageInputField: chatMessageInputField,
      ),
    );
  }
}
