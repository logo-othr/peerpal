import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/message_type.dart';
import 'package:peerpal/chat/presentation/chat/chat_bottom_bar/chat_input_panel_content.dart';
import 'package:peerpal/chat/presentation/chat/chat_loaded/chat_loaded_cubit.dart';
import 'package:peerpal/chat/presentation/chat/chat_loading/cubit/chat_page_cubit.dart';
import 'package:peerpal/chat/presentation/chat/widgets/chat_message_input_field.dart';
import 'package:peerpal/chat/presentation/chat/widgets/friend_request_button.dart';
import 'package:peerpal/chat/presentation/chat/widgets/message_list.dart';
import 'package:peerpal/chat/presentation/chat_header_bar.dart';
import 'package:peerpal/chat/presentation/user_detail_page/user_detail_page.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/friends/domain/repository/friend_repository.dart';
import 'package:peerpal/setup.dart';

class ChatLoaded extends StatelessWidget {
  final TextEditingController _textEditingController;
  final FocusNode _focus;

  const ChatLoaded(
      {Key? key,
      required TextEditingController textEditingController,
      required FocusNode focus})
      : this._textEditingController = textEditingController,
        this._focus = focus,
        super(key: key);

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

  Future<void> _sendTextMessage(String content, BuildContext context) async {
    _textEditingController.clear();
    context
        .read<ChatLoadedCubit>()
        .sendMessage(payload: content, messageType: MessageType.text);
  }

  Future<XFile> _pickPictureFromGallery() async {
    var profilePicture = (await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1280,
      maxWidth: 720,
      imageQuality: 45,
    ))!;
    return profilePicture;
  }

  Future<void> _sendImageMessage(String content, BuildContext context) async {
    var image = await _pickPictureFromGallery();
    String url = await context.read<ChatLoadedCubit>().postPicture(image);
    context
        .read<ChatLoadedCubit>()
        .sendMessage(payload: url, messageType: MessageType.image);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatLoadedCubit, ChatLoadedState>(
      builder: (context, state) {
        return Column(
          children: [
            _chatHeaderBar(context, state.currentChat.user),
            FriendRequestButton(
              chatPartner: state.currentChat.user,
              appUserRepository: sl<AppUserRepository>(),
              friendRepository: sl<FriendRepository>(),
            ),
            MessageList(state: state),
            ChatInputPanelContent(
              appUser: state.currentUser,
              chatMessageController: _textEditingController,
              chatPartner: state.currentChat!.user,
              chatMessageInputField: ChatMessageInputField(
                sendImageMessage: () =>
                    _sendImageMessage(_textEditingController.text, context),
                textEditingController: _textEditingController,
                focus: _focus,
                sendTextMessage: () =>
                    _sendTextMessage(_textEditingController.text, context),
              ),
              userChat: state.currentChat,
              currentUserId: sl<AuthenticationRepository>().currentUser.id,
            ),
          ],
        );
      },
    );
  }
}
