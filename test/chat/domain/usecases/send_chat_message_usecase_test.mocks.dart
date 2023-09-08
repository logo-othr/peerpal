// Mocks generated by Mockito 5.4.0 from annotations
// in peerpal/test/chat/domain/usecases/send_chat_message_usecase_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:peerpal/chat/domain/message_type.dart' as _i6;
import 'package:peerpal/chat/domain/models/chat.dart' as _i4;
import 'package:peerpal/chat/domain/models/chat_message.dart' as _i7;
import 'package:peerpal/chat/domain/repository/chat_repository.dart' as _i2;
import 'package:peerpal/discover_feed/domain/peerpal_user.dart' as _i5;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [ChatRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockChatRepository extends _i1.Mock implements _i2.ChatRepository {
  MockChatRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Stream<List<_i4.Chat>> getChats() => (super.noSuchMethod(
        Invocation.method(
          #getChats,
          [],
        ),
        returnValue: _i3.Stream<List<_i4.Chat>>.empty(),
      ) as _i3.Stream<List<_i4.Chat>>);
  @override
  _i3.Future<void> sendChatMessage(
    _i5.PeerPALUser? userInformation,
    String? chatId,
    String? message,
    _i6.MessageType? type,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendChatMessage,
          [
            userInformation,
            chatId,
            message,
            type,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> sendChatRequestResponse(
    String? chatPartnerId,
    bool? response,
    String? chatId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendChatRequestResponse,
          [
            chatPartnerId,
            response,
            chatId,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Stream<int> messageCountForChat(String? chatId) => (super.noSuchMethod(
        Invocation.method(
          #messageCountForChat,
          [chatId],
        ),
        returnValue: _i3.Stream<int>.empty(),
      ) as _i3.Stream<int>);
  @override
  _i3.Stream<List<_i7.ChatMessage>> getChatMessagesForChat(String? chatId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getChatMessagesForChat,
          [chatId],
        ),
        returnValue: _i3.Stream<List<_i7.ChatMessage>>.empty(),
      ) as _i3.Stream<List<_i7.ChatMessage>>);
}
