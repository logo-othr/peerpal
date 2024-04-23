import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peerpal/app_logger.dart';
import 'package:peerpal/chat/domain/message_type.dart';
import 'package:peerpal/chat/domain/usecases/send_chat_message_usecase.dart';
import 'package:peerpal/chat/presentation/chat/chat_loading/cubit/chat_page_cubit.dart';
import 'package:uuid/uuid.dart';

part 'chat_loaded_state.dart';

class ChatLoadedCubit extends Cubit<ChatLoadedState> {
  final SendChatMessageUseCase _sendMessage;

  ChatLoadedCubit({
    required sendMessage,
    required chatLoadedState,
  })  : this._sendMessage = sendMessage,
        super(chatLoadedState);

  Future<void> sendMessage({
      required String payload,
      required MessageType messageType}) async {
    var chatPartner = state.chatPartner;
    var chatId = state.currentChat.chat.chatId;

    if (payload.trim() != '') {
      await _sendMessage(
        chatPartner,
        chatId,
        payload,
        messageType,
      );
    }
  }

  Future<String> postPicture(XFile? chatImage) async {
    var currentChat = state.currentChat;
    var uid = Uuid();
    firebase_storage.UploadTask uploadTask;
    var ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('User-Chat-Image')
        .child(currentChat!.chat.chatId)
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
}
