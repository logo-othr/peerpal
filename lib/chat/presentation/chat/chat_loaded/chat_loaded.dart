import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peerpal/app_logger.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/message_type.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/presentation/chat/chat_bottom_bar/chat_bottom_bar.dart';
import 'package:peerpal/chat/presentation/chat/chat_loaded/chat_loaded_cubit.dart';
import 'package:peerpal/chat/presentation/chat/chat_page/bloc/chat_page_bloc.dart';
import 'package:peerpal/chat/presentation/chat/view/chat_message_input_field.dart';
import 'package:peerpal/chat/presentation/chat/view/friend_request_button.dart';
import 'package:peerpal/chat/presentation/chat/view/message_list.dart';
import 'package:peerpal/chat/presentation/chat_header_bar.dart';
import 'package:peerpal/chat/presentation/user_detail_page/user_detail_page.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/setup.dart';
import 'package:uuid/uuid.dart';

class ChatLoaded extends StatelessWidget {
  final ChatLoadedState _state;
  final TextEditingController _textEditingController;
  final FocusNode _focus;

  const ChatLoaded(
      {Key? key,
      required ChatLoadedState state,
      required TextEditingController textEditingController,
      required FocusNode focus})
      : this._state = state,
        this._textEditingController = textEditingController,
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

  Future<void> _sendTextMessage(PeerPALUser chatPartner, String? chatId,
      String content, BuildContext context) async {
    _textEditingController.clear();
    context.read<ChatLoadedCubit>().sendMessage(
        chatPartner: chatPartner,
        chatId: chatId,
        payload: content,
        messageType: MessageType.text);
  }

  Future<XFile> pickPictureFromGallery() async {
    var profilePicture = (await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1280,
      maxWidth: 720,
      imageQuality: 45,
    ))!;
    return profilePicture;
  }

  Future<void> _sendImageMessage(PeerPALUser chatPartner, String? chatId,
      String content, BuildContext context) async {
    var image = await pickPictureFromGallery();
    String url = await postPicture(image, _state.userChat);
    context.read<ChatLoadedCubit>().sendMessage(
        chatPartner: chatPartner,
        chatId: chatId,
        payload: url,
        messageType: MessageType.image);
  }

  Future<String> postPicture(XFile? chatImage, UserChat? userChat) async {
    var uid = Uuid();

    firebase_storage.UploadTask uploadTask;
    var ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('User-Chat-Image')
        .child(userChat!.chat.chatId)
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .child('${uid.v4()}.jpg');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'file-path': chatImage!.path});

    uploadTask = ref.putFile(File(chatImage.path), metadata);

    var returnURL = '';
    await Future.value(uploadTask);
    await ref.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    logger.i(returnURL);
    return returnURL;
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
            sendImageMessage: () => _sendImageMessage(
                _state.chatPartner,
                _state.userChat.chat.chatId,
                _textEditingController.text,
                context),
            textEditingController: _textEditingController,
            focus: _focus,
            sendTextMessage: () => _sendTextMessage(
                _state.chatPartner,
                _state.userChat.chat.chatId,
                _textEditingController.text,
                context),
          ),
          userChat: _state.userChat,
          currentUserId: sl<AuthenticationRepository>().currentUser.id,
        ),
      ],
    );
  }
}
