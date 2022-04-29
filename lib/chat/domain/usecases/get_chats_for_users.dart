import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

class GetChatsForUser {
  final ChatRepository chatRepository;
  final AppUserRepository appUserRepository;

  GetChatsForUser(this.chatRepository, this.appUserRepository);

  Stream<List<Chat>> call() {
    String appUserId = appUserRepository.currentUser.id;
    return chatRepository.getChatListForUserId(appUserId);
  }
}
