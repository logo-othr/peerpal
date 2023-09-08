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
import 'package:peerpal/chat/domain/usecases/get_all_userchats.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

import 'get_all_userchats_test.mocks.dart';

@GenerateMocks([ChatRepository, AppUserRepository, AuthenticationRepository])
void main() {
  const appUserId = "123";
  const chatPartnerId = "456";
  const chatPartnerId2 = "987";

  late MockChatRepository mockChatRepository;
  late MockAppUserRepository mockUserRepository;
  late MockAuthenticationRepository mockAuthRepository;
  late GetAllUserChats getAllUserChats;

  setUp(() {
    mockChatRepository = MockChatRepository();
    mockUserRepository = MockAppUserRepository();
    mockAuthRepository = MockAuthenticationRepository();
    getAllUserChats = GetAllUserChats(
      chatRepository: mockChatRepository,
      userRepository: mockUserRepository,
      authenticationRepository: mockAuthRepository,
    );
  });

  test('should fetch all user chats', () async {
    final mockChats = [
      Chat(
          uids: [appUserId, chatPartnerId],
          chatRequestAccepted: true,
          startedBy: chatPartnerId,
          lastMessage: ChatMessage(
              message: 'Letzte Nachricht',
              timestamp: '928918391',
              type: MessageType.text.toUIString,
              userId: chatPartnerId),
          chatId: '123-456-789',
          lastUpdated: '12029391'),
      Chat(
          uids: [chatPartnerId2, appUserId],
          chatRequestAccepted: false,
          startedBy: appUserId,
          lastMessage: ChatMessage(
              message: 'Letzte Nachricht',
              timestamp: '928918391',
              type: MessageType.text.toUIString,
              userId: appUserId),
          chatId: '789-456-123',
          lastUpdated: '12029391')
    ];

    final chatPartner1 = PeerPALUser(id: chatPartnerId);
    final chatPartner2 = PeerPALUser(id: chatPartnerId2);
    final currentUser = PeerPALUser(id: appUserId);
    final mockAuthUser = AuthUser(id: '0000');

    when(mockAuthRepository.currentUser).thenReturn(mockAuthUser);
    when(mockChatRepository.getChats())
        .thenAnswer((_) => Stream.value(mockChats));
    when(mockUserRepository.getUser(chatPartnerId))
        .thenAnswer((_) async => chatPartner1);
    when(mockUserRepository.getUser(chatPartnerId2))
        .thenAnswer((_) async => chatPartner2);
    when(mockUserRepository.getUser(appUserId))
        .thenAnswer((_) async => currentUser);

    final result = await getAllUserChats.call().first;

    expect(result, [
      UserChat(chat: mockChats[0], user: chatPartner1),
      UserChat(chat: mockChats[1], user: chatPartner2),
    ]);
  });
}
