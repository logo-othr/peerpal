import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:peerpal/chatv2/domain/repositorys/chat_repository.dart';
import 'package:peerpal/chatv2/domain/usecases/send_request_response.dart';

import 'send_request_response_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late SendRequestResponse usecase;
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    usecase = SendRequestResponse(mockChatRepository);
  });

  final String userId = "1";
  final String partnerId = "2";
  final String chatId = '1';
  final bool response = true;

  test(
      'should forward sendRequestResponse call to repository with correct parameters',
      () async {
    await usecase(userId, partnerId, response, chatId);

    verify(mockChatRepository.sendChatRequestResponse(
            partnerId, response, chatId))
        .called(1);
    verifyNoMoreInteractions(mockChatRepository);
  });
}
