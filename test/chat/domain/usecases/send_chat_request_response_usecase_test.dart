import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecases/send_chat_request_response_usecase.dart';

import 'send_chat_request_response_usecase_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late SendChatRequestResponseUseCase sendChatRequestResponseUseCase;
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    sendChatRequestResponseUseCase =
        SendChatRequestResponseUseCase(mockChatRepository);
  });

  test('should forward the call to ChatRepository for chat request response',
      () async {
    final mockCurrentUserId = '123-000-111';
    final mockChatPartnerId = '123-222-333';
    final mockResponse = true;
    final mockChatId = '123-456-789';

    when(mockChatRepository.sendChatRequestResponse(
            mockChatPartnerId, mockResponse, mockChatId))
        .thenAnswer((_) async => null);

    await sendChatRequestResponseUseCase.call(
        mockCurrentUserId, mockChatPartnerId, mockResponse, mockChatId);

    verify(mockChatRepository.sendChatRequestResponse(
            mockChatPartnerId, mockResponse, mockChatId))
        .called(1);
  });
}
