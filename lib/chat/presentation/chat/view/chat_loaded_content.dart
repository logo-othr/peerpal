import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/presentation/chat/bloc/chat_page_bloc.dart';
import 'package:peerpal/chat/presentation/chat/view/chat_bottom_bar.dart';
import 'package:peerpal/chat/presentation/chat/view/chat_message_input_field.dart';
import 'package:peerpal/chat/presentation/chat/view/friend_request_button.dart';
import 'package:peerpal/chat/presentation/chat/view/message_list.dart';
import 'package:peerpal/chat/presentation/user_detail_page/user_detail_page.dart';
import 'package:peerpal/chat/single_chat_header_widget.dart';
import 'package:peerpal/peerpal_user/data/repository/app_user_repository.dart';
import 'package:peerpal/peerpal_user/domain/peerpal_user.dart';
import 'package:peerpal/setup.dart';

class ChatLoadedContent extends StatelessWidget {
  final ChatLoadedState _state;
  final TextEditingController _textEditingController;
  final FocusNode _focus;

  const ChatLoadedContent(
      {Key? key,
      required ChatLoadedState state,
      required TextEditingController textEditingController,
      required FocusNode focus})
      : this._state = state,
        this._textEditingController = textEditingController,
        this._focus = focus,
        super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _chatHeaderBar(context, _state.chatPartner),
        FriendRequestButton(
            chatPartner: _state.chatPartner,
            appUserRepository: sl<AppUserRepository>()),
        MessageList(state: _state),
        ChatBottomBar(
          appUser: _state.appUser,
          chatMessageController: _textEditingController,
          chatPartner: _state.chatPartner,
          chatMessageInputField: ChatMessageInputField(
            sendImage: () => {},
            textEditingController: _textEditingController,
            focus: _focus,
            sendTextMessage: () => _sendChatMessage(
                _state.chatPartner,
                _state.userChat.chat.chatId,
                _textEditingController.text,
                "0",
                context),
          ),
          userChat: _state.userChat,
          currentUserId: sl<AuthenticationRepository>().currentUser.id,
        ),
      ],
    );
  }
}
