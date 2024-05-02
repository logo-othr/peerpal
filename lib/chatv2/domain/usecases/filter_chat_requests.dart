import 'package:peerpal/chatv2/domain/models/chat.dart';

class GetChatRequests {
  GetChatRequests();

  Stream<List<Chat>> call(Stream<List<Chat>> chatStream, String userId) async* {
    await for (List<Chat> chatList in chatStream) {
      final List<Chat?> userChats =
          await Future.wait(chatList.map((chat) async {
        if (chat.chatRequestAccepted == false && chat.startedBy != userId) {
          return chat;
        }
      }));

      yield userChats.whereType<Chat>().toList();
    }
  }
}
