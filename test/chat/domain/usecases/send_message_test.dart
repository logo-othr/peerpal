import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:peerpal/chat/domain/enums/message_type.dart';
import 'package:peerpal/chat/domain/repositorys/chat_repository.dart';
import 'package:peerpal/chat/domain/usecases/send_message.dart';

import 'send_message_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late SendMessage usecase;
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    usecase = SendMessage(mockChatRepository);
  });

  final String partnerId = "1";
  final String? chatId = '1';
  final String content = 'Hello!';
  final MessageType type = MessageType.text;

  test('should forward call to repository with correct parameters', () async {
    await usecase(partnerId, chatId, content, type);

    verify(mockChatRepository.sendMessage(partnerId, chatId, content, type))
        .called(1);
    verifyNoMoreInteractions(mockChatRepository);
  });
}
