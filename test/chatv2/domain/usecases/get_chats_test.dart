import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:peerpal/chatv2/domain/models/chat.dart';
import 'package:peerpal/chatv2/domain/models/chat_message.dart';
import 'package:peerpal/chatv2/domain/repositorys/chat_repository.dart';
import 'package:peerpal/chatv2/domain/usecases/get_chats.dart';

import 'get_chats_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late GetChats usecase;
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    usecase = GetChats(mockChatRepository);
  });

  final ChatMessage? chatMessage1 =
      ChatMessage(message: 'test', timestamp: '1', type: 'text', userId: '1');

  final Chat chat1 = Chat(
      uids: ['1', '2'],
      chatId: '1',
      chatRequestAccepted: true,
      lastMessage: chatMessage1,
      lastUpdated: '1',
      startedBy: '1');

  final List<Chat> chatlist = [chat1];

  final String userId = "1";
  final chatStream = Stream<List<Chat>>.fromIterable([chatlist]);

  test(
    'should get a stream of lists, containing chat objects, for the userid, from the repository',
    () async {
      when(mockChatRepository.chatsStream(any)).thenAnswer((_) => chatStream);

      final resultStream = await usecase(userId);

      await expectLater(resultStream, emitsInOrder([chatlist, emitsDone]));

      verify(mockChatRepository.chatsStream(userId)).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    },
  );
}
