import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/chat/domain/repositorys/chat_repository.dart';
import 'package:peerpal/chat/domain/usecases/get_messages.dart';

import 'get_messages_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late GetMessages usecase;
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    usecase = GetMessages(mockChatRepository);
  });

  final ChatMessage chatMessage1 =
      ChatMessage(message: 'test', timestamp: '1', type: 'text', userId: '1');
  final ChatMessage chatMessage2 =
      ChatMessage(message: 'test2', timestamp: '2', type: 'text', userId: '1');
  final List<ChatMessage> chatlist = [chatMessage1, chatMessage2];

  final String chatId = "1";
  final messageStream = Stream<List<ChatMessage>>.fromIterable([chatlist]);

  test(
    'should get a stream of lists, containing message objects, for the chatId, from the repository',
    () async {
      when(mockChatRepository.messageStream(any))
          .thenAnswer((_) => messageStream);

      final resultStream = usecase(chatId);

      await expectLater(resultStream, emitsInOrder([chatlist]));

      verify(mockChatRepository.messageStream(chatId)).called(1);

      verifyNoMoreInteractions(mockChatRepository);
    },
  );
}
