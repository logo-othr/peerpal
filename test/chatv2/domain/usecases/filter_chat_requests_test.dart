import 'package:flutter_test/flutter_test.dart';
import 'package:peerpal/chatv2/domain/models/chat.dart';
import 'package:peerpal/chatv2/domain/models/chat_message.dart';
import 'package:peerpal/chatv2/domain/usecases/filter_chat_requests.dart';

void main() {
  group('GetChatRequests', () {
    late GetChatRequests usecase;
    late Stream<List<Chat>> chatStream;

    setUp(() {
      usecase = GetChatRequests();
    });

    final userId = '123';
    final partnerId = '456';
    final ChatMessage? chatMessage1 =
        ChatMessage(message: 'test', timestamp: '1', type: 'text', userId: '1');

    // Started by other, not accepted
    final Chat chat1 = Chat(
      uids: [userId, partnerId],
      chatId: '1',
      lastMessage: chatMessage1,
      chatRequestAccepted: false,
      lastUpdated: '1',
      startedBy: partnerId,
    );

    // started by other, accepted
    final Chat chat2 = Chat(
      uids: [userId, partnerId],
      chatId: '2',
      lastMessage: chatMessage1,
      chatRequestAccepted: true,
      lastUpdated: '1',
      startedBy: partnerId,
    );

    // started by me, not accepted
    final Chat chat3 = Chat(
      uids: [userId, partnerId],
      chatId: '3',
      lastMessage: chatMessage1,
      chatRequestAccepted: false,
      lastUpdated: '1',
      startedBy: userId,
    );

    // started by me, accepted
    final Chat chat4 = Chat(
      uids: [userId, partnerId],
      chatId: '4',
      lastMessage: chatMessage1,
      chatRequestAccepted: true,
      lastUpdated: '1',
      startedBy: userId,
    );

    final chats = [chat1, chat2, chat3, chat4];
    chatStream = Stream.fromIterable([chats]);

    test(
      'should filter and return a stream of chat objects that are unaccepted and not started by the user',
      () async {
        final result = usecase(chatStream, userId);
        await expectLater(
            result, emits([chat1])); // Expects to receive only unacceptedChat
      },
    );
  });
}
