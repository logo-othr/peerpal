import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chat/domain/message_type.dart';
import 'package:peerpal/chat/domain/usecases/send_chat_message_usecase.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

part 'chat_loaded_state.dart';

class ChatLoadedCubit extends Cubit<ChatLoadedBasicState> {
  final SendChatMessageUseCase _sendMessage;

  ChatLoadedCubit({
    required sendMessage,
  })  : this._sendMessage = sendMessage,
        super(InitialChatLoadedState());

  Future<void> sendMessage(
      {required PeerPALUser chatPartner,
      required String? chatId,
      required String payload,
      required MessageType messageType}) async {
    if (payload.trim() != '') {
      await _sendMessage(
        chatPartner,
        chatId,
        payload,
        messageType,
      );
    }
  }
}
