import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:peerpal/authentication/domain/models/auth_user.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/message_type.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/chat/domain/models/user_chat.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecases/get_chat_requests_usecase.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

import 'get_chat_requests_usecase_test.mocks.dart';

@GenerateMocks([ChatRepository, AppUserRepository, AuthenticationRepository])
void main() {
  late MockChatRepository mockChatRepository;
  late MockAppUserRepository mockAppUserRepository;
  late MockAuthenticationRepository mockAuthenticationRepository;
  late GetChatRequestsUseCase getChatRequestsUseCase;

  const appUserId = "123";
  const chatInitiatorId = "456";

  setUp(() {
    mockChatRepository = MockChatRepository();
    mockAppUserRepository = MockAppUserRepository();
    mockAuthenticationRepository = MockAuthenticationRepository();

    getChatRequestsUseCase = GetChatRequestsUseCase(
      mockChatRepository,
      mockAppUserRepository,
      mockAuthenticationRepository,
    );
  });

  test('should fetch chat requests for the current user', () async {
    final mockChatList = [
      UserChat(
        chat: Chat(
            uids: [appUserId, chatInitiatorId],
            chatRequestAccepted: false,
            startedBy: chatInitiatorId,
            lastMessage: ChatMessage(
                message: 'Some Message',
                timestamp: '928918391',
                type: MessageType.text.toUIString,
                userId: chatInitiatorId),
            chatId: '123-456-789',
            lastUpdated: '12029391'),
        user: PeerPALUser(id: chatInitiatorId),
      ),
      UserChat(
        chat: Chat(
            uids: [appUserId, chatInitiatorId],
            chatRequestAccepted: true,
            startedBy: appUserId,
            lastMessage: ChatMessage(
                message: 'Another Message',
                timestamp: '928918392',
                type: MessageType.text.toUIString,
                userId: appUserId),
            chatId: '789-123-456',
            lastUpdated: '12029392'),
        user: PeerPALUser(id: appUserId),
      ),
    ];

    final mockAuthUser = AuthUser(id: appUserId);

    when(mockAuthenticationRepository.currentUser).thenReturn(mockAuthUser);

    final chatStreamController = StreamController<List<UserChat>>();
    chatStreamController.add(mockChatList);
    final chatStream = chatStreamController.stream;

    final resultStream = getChatRequestsUseCase.call(chatStream);

    expect(await resultStream.first, [mockChatList[0]]);
  });
}
