import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chat/presentation/chat/bloc/chat_page_bloc.dart';
import 'package:peerpal/chat/presentation/chat/view/chat_loaded_content.dart';
import 'package:peerpal/chat/presentation/chat/view/chat_message_input_field.dart';
import 'package:peerpal/chat/presentation/chat/view/friend_request_button.dart';
import 'package:peerpal/chat/presentation/user_detail_page/user_detail_page.dart';
import 'package:peerpal/chat/single_chat_header_widget.dart';
import 'package:peerpal/peerpal_user/data/repository/app_user_repository.dart';
import 'package:peerpal/peerpal_user/domain/peerpal_user.dart';
import 'package:peerpal/setup.dart';
import 'package:peerpal/widgets/chat_buttons.dart';
import 'package:provider/provider.dart';

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
          } else if (state is ChatPageLoading) {
            return _chatContentLoading(context, state);
          } else if (state is ChatLoadedState) {
            return ChatLoadedContent(
              state: state,
              focus: _focus,
              textEditingController: _textEditingController,
            );
          } else if (state is WaitingForChatOrFirstMessage) {
            return _chatContentWaitingForChatOrFirstMessage(context, state);
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

  Widget _chatContentWaitingForChatOrFirstMessage(
      BuildContext context, WaitingForChatOrFirstMessage state) {
    return Column(
      children: [
        _chatHeaderBar(context, state.chatPartner),
        FriendRequestButton(
            chatPartner: state.chatPartner,
            appUserRepository: sl<AppUserRepository>()),
        Spacer(),
        ChatButtons(state.appUser.phoneNumber,
            textEditingController: _textEditingController),
        ChatMessageInputField(
          textEditingController: _textEditingController,
          focus: _focus,
          sendTextMessage: () => _sendChatMessage(state.chatPartner, null,
              _textEditingController.text, "0", context),
          sendImage: () => {},
        ),
      ],
    );
  }

  Widget _chatContentLoading(BuildContext context, ChatPageLoading state) {
    return Column(
      children: [
        _chatHeaderBar(context, state.chatPartner),
        FriendRequestButton(
          chatPartner: state.chatPartner,
          appUserRepository: sl<AppUserRepository>(),
        ),
      ],
    );
  }

  // ToDo: DRY
  Widget _chatHeaderBar(BuildContext context, PeerPALUser user) {
    return ChatHeaderBar(
      name: user.name,
      urlAvatar: user.imagePath,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailPage(
              user.id!,
              hasMessageButton: false,
            ),
          ),
        );
      },
    );
  }

  // ToDo: DRY
  Future<void> _sendChatMessage(PeerPALUser chatPartner, String? chatId,
      String content, String type, BuildContext context) async {
    _textEditingController.clear();
    context.read<ChatPageBloc>()
      ..add(SendMessageEvent(
        chatPartner: chatPartner,
        chatId: chatId,
        message: content,
        type: type,
      ));
  }
}

