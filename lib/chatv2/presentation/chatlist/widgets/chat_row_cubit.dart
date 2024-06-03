import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/chatv2/domain/models/chat.dart';
import 'package:peerpal/chatv2/domain/usecases/get_user.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';

part 'chat_row_state.dart';

class ChatRowCubit extends Cubit<ChatRowState> {
  final GetUser getUser;
  final GetAuthenticatedUser getAppUser;

  ChatRowCubit(this.getUser, this.getAppUser) : super(ChatRowState());

  Future<void> loadChatRow(Chat chat) async {
    PeerPALUser appUser = await getAppUser();
    var chatPartnerId =
        chat.uids.firstWhere((element) => element != appUser.id);
    var user = await getUser(chatPartnerId);
    emit(state.copyWith(status: ChatRowStatus.success, user: user, chat: chat));
  }
}
