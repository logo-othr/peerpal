import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chat/domain/message_type.dart';
import 'package:peerpal/chat/presentation/chat/chat_loading/cubit/chat_page_cubit.dart';
import 'package:peerpal/chat/presentation/chat/widgets/chat_message_input_field.dart';
import 'package:peerpal/chat/presentation/chat/widgets/friend_request_button.dart';
import 'package:peerpal/chat/presentation/chat_header_bar.dart';
import 'package:peerpal/chat/presentation/user_detail_page/user_detail_page.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/setup.dart';
import 'package:peerpal/widgets/chat_buttons.dart';

class NewChat extends StatelessWidget {
  final NewChatState _state;
  final TextEditingController _textEditingController;
  final FocusNode _focus;

  const NewChat({
    Key? key,
    required NewChatState state,
    required TextEditingController textEditingController,
    required FocusNode focusNode,
  })  : this._state = state,
        this._textEditingController = textEditingController,
        this._focus = focusNode,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _chatHeaderBar(context, _state.chatPartner),
        FriendRequestButton(
            chatPartner: _state.chatPartner,
            appUserRepository: sl<AppUserRepository>()),
        Spacer(),
        Center(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Text(
              "Schreibe eine Nachricht, um ${_state.chatPartner.name} eine Chat-Anfrage zu schicken"),
        )),
        Spacer(),
        ChatButtons(_state.currentUser.phoneNumber,
            textEditingController: _textEditingController),
        ChatMessageInputField(
            textEditingController: _textEditingController,
            focus: _focus,
            sendTextMessage: () => _sendChatMessage(
                _state.chatPartner, null, _textEditingController.text, context),
            sendImageMessage: null),
      ],
    );
  }

  Widget _chatHeaderBar(BuildContext context, PeerPALUser chatPartner) {
    return ChatHeaderBar(
        chatPartner: chatPartner,
        onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserInformationPage(
                  chatPartner.id!,
                  hasMessageButton: false,
                ),
              ),
            ));
  }

  Future<void> _sendChatMessage(PeerPALUser chatPartner, String? chatId,
      String content, BuildContext context) async {
    _textEditingController.clear();
    context.read<ChatPageCubit>().sendMessage(
          chatPartner: chatPartner,
          chatId: chatId,
          payload: content,
          type: MessageType.text,
        );
  }
}