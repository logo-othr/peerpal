import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:peerpal/chat/domain/message_type.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecases/send_chat_message_usecase.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

import 'send_chat_message_usecase_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late SendChatMessageUseCase sendChatMessageUseCase;
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    sendChatMessageUseCase = SendChatMessageUseCase(mockChatRepository);
  });

  test('should forward the call to ChatRepository', () async {
    final mockChatPartner = PeerPALUser();
    final mockChatId = '123-456-789';
    final mockContent = 'Hi';
    final mockType = MessageType.text;

    when(mockChatRepository.sendChatMessage(
            mockChatPartner, mockChatId, mockContent, mockType))
        .thenAnswer((_) async => null);

    await sendChatMessageUseCase.call(
        mockChatPartner, mockChatId, mockContent, mockType);

    verify(mockChatRepository.sendChatMessage(
            mockChatPartner, mockChatId, mockContent, mockType))
        .called(1);
  });
}
