part 'chat_loaded_state.dart';

/*
class ChatLoadedCubit extends Cubit<ChatLoadedBasicState> {
  final SendChatMessageUseCase sendMessageUseCase;

  ChatLoadedCubit({
    required this.sendMessageUseCase,
  }) : super(InitialChatLoadedState());

  Future<void> sendTextMessage(PeerPALUser chatPartner, String? chatId,
      String content, BuildContext context) async {
  //  _messagingService.sendTextMessage(chatPartner, chatId, content, context);
    emit(state.copyWith());
  }

  Future<void> sendImageMessage(PeerPALUser chatPartner, String? chatId,
      String content, BuildContext context) async {
    var image = await pickPictureFromGallery();
    String url = await postPicture(image, _state.userChat);
    _messagingService.sendImageMessage(chatPartner, chatId, url, context);
    emit(state.copyWith());
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
}
*/
