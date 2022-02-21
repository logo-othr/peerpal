import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';

class GetMessagesForChat {
  final ChatRepository chatRepository;
  GetMessagesForChat(this.chatRepository);

  Stream<List<ChatMessage>> call(UserChat userChat)  {
    Stream<List<ChatMessage>> chatMessageStream = chatRepository.getChatMessagesForChat(userChat.chat.chatId);
    return chatMessageStream;
  }
}