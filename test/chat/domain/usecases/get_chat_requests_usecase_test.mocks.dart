// Mocks generated by Mockito 5.4.0 from annotations
// in peerpal/test/chat/domain/usecases/get_chat_requests_usecase_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;

import 'package:cloud_firestore/cloud_firestore.dart' as _i12;
import 'package:mockito/mockito.dart' as _i1;
import 'package:peerpal/app/data/location/dto/location.dart' as _i14;
import 'package:peerpal/app/domain/core/cache.dart' as _i2;
import 'package:peerpal/authentication/domain/models/auth_user.dart' as _i5;
import 'package:peerpal/authentication/persistence/authentication_repository.dart'
    as _i15;
import 'package:peerpal/chat/domain/message_type.dart' as _i9;
import 'package:peerpal/chat/domain/models/chat.dart' as _i8;
import 'package:peerpal/chat/domain/models/chat_message.dart' as _i10;
import 'package:peerpal/chat/domain/repository/chat_repository.dart' as _i6;
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart'
    as _i11;
import 'package:peerpal/discover_feed/domain/peerpal_user.dart' as _i3;
import 'package:peerpal/discover_setup/pages/discover_communication/domain/enum/communication_type.dart'
    as _i13;
import 'package:rxdart/rxdart.dart' as _i4;

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

class _FakeCache_0 extends _i1.SmartFake implements _i2.Cache {
  _FakeCache_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePeerPALUser_1 extends _i1.SmartFake implements _i3.PeerPALUser {
  _FakePeerPALUser_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBehaviorSubject_2<T> extends _i1.SmartFake
    implements _i4.BehaviorSubject<T> {
  _FakeBehaviorSubject_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAuthUser_3 extends _i1.SmartFake implements _i5.AuthUser {
  _FakeAuthUser_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ChatRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockChatRepository extends _i1.Mock implements _i6.ChatRepository {
  MockChatRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Stream<List<_i8.Chat>> getChats() => (super.noSuchMethod(
        Invocation.method(
          #getChats,
          [],
        ),
        returnValue: _i7.Stream<List<_i8.Chat>>.empty(),
      ) as _i7.Stream<List<_i8.Chat>>);
  @override
  _i7.Future<void> sendChatMessage(
    _i3.PeerPALUser? userInformation,
    String? chatId,
    String? message,
    _i9.MessageType? type,
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
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> sendChatRequestResponse(
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
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Stream<int> messageCountForChat(String? chatId) => (super.noSuchMethod(
        Invocation.method(
          #messageCountForChat,
          [chatId],
        ),
        returnValue: _i7.Stream<int>.empty(),
      ) as _i7.Stream<int>);
  @override
  _i7.Stream<List<_i10.ChatMessage>> getChatMessagesForChat(String? chatId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getChatMessagesForChat,
          [chatId],
        ),
        returnValue: _i7.Stream<List<_i10.ChatMessage>>.empty(),
      ) as _i7.Stream<List<_i10.ChatMessage>>);
}

/// A class which mocks [AppUserRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppUserRepository extends _i1.Mock implements _i11.AppUserRepository {
  MockAppUserRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Cache get cache => (super.noSuchMethod(
        Invocation.getter(#cache),
        returnValue: _FakeCache_0(
          this,
          Invocation.getter(#cache),
        ),
      ) as _i2.Cache);
  @override
  _i7.Future<void> updateUser(_i3.PeerPALUser? peerPALUser) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUserInformation,
          [peerPALUser],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> updateServerNameCache(dynamic userName) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateServerNameCache,
          [userName],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<_i3.PeerPALUser> getUser(String? uid) => (super.noSuchMethod(
        Invocation.method(
          #getUser,
          [uid],
        ),
        returnValue: _i7.Future<_i3.PeerPALUser>.value(_FakePeerPALUser_1(
          this,
          Invocation.method(
            #getUser,
            [uid],
          ),
        )),
      ) as _i7.Future<_i3.PeerPALUser>);
  @override
  _i7.Future<List<_i3.PeerPALUser>> findUserByName(
    String? userName, {
    List<String>? ignoreList = const [],
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #findUserByName,
          [userName],
          {#ignoreList: ignoreList},
        ),
        returnValue:
            _i7.Future<List<_i3.PeerPALUser>>.value(<_i3.PeerPALUser>[]),
      ) as _i7.Future<List<_i3.PeerPALUser>>);

  @override
  _i7.Future<_i4.BehaviorSubject<List<_i3.PeerPALUser>>> findPeers(
    String? authenticatedUserId, {
    int? limit = 4,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMatchingUsersPaginatedStream,
          [authenticatedUserId],
          {#limit: limit},
        ),
        returnValue:
            _i7.Future<_i4.BehaviorSubject<List<_i3.PeerPALUser>>>.value(
                    _FakeBehaviorSubject_2<List<_i3.PeerPALUser>>(
              this,
              Invocation.method(
                #getMatchingUsersPaginatedStream,
                [authenticatedUserId],
                {#limit: limit},
              ),
            )),
          ) as _i7.Future<_i4.BehaviorSubject<List<_i3.PeerPALUser>>>);
  @override
  _i3.PeerPALUser? convertDocumentSnapshotToPeerPALUser(
          _i12.DocumentSnapshot<Object?>? document) =>
      (super.noSuchMethod(Invocation.method(
        #convertDocumentSnapshotToPeerPALUser,
        [document],
      )) as _i3.PeerPALUser?);
  @override
  _i7.Future<_i3.PeerPALUser> getCurrentUserInformation(String? uid) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCurrentUserInformation,
          [uid],
        ),
        returnValue: _i7.Future<_i3.PeerPALUser>.value(_FakePeerPALUser_1(
          this,
          Invocation.method(
            #getCurrentUserInformation,
            [uid],
          ),
        )),
      ) as _i7.Future<_i3.PeerPALUser>);
  @override
  List<_i13.CommunicationType> loadCommunicationList() => (super.noSuchMethod(
        Invocation.method(
          #loadCommunicationList,
          [],
        ),
        returnValue: <_i13.CommunicationType>[],
      ) as List<_i13.CommunicationType>);
  @override
  _i7.Future<List<_i14.Location>> loadLocations() => (super.noSuchMethod(
        Invocation.method(
          #loadLocations,
          [],
        ),
        returnValue: _i7.Future<List<_i14.Location>>.value(<_i14.Location>[]),
      ) as _i7.Future<List<_i14.Location>>);
  @override
  _i7.Future<void> sendFriendRequestToUser(_i3.PeerPALUser? userInformation) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendFriendRequestToUser,
          [userInformation],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> canceledFriendRequest(_i3.PeerPALUser? userInformation) =>
      (super.noSuchMethod(
        Invocation.method(
          #canceledFriendRequest,
          [userInformation],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> friendRequestResponse(
    _i3.PeerPALUser? userInformation,
    bool? response,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #friendRequestResponse,
          [
            userInformation,
            response,
          ],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Stream<List<_i3.PeerPALUser>> getFriendList() => (super.noSuchMethod(
        Invocation.method(
          #getFriendList,
          [],
        ),
        returnValue: _i7.Stream<List<_i3.PeerPALUser>>.empty(),
      ) as _i7.Stream<List<_i3.PeerPALUser>>);
  @override
  _i7.Stream<List<_i3.PeerPALUser>> getSentFriendRequestsFromUser() =>
      (super.noSuchMethod(
        Invocation.method(
          #getSentFriendRequestsFromUser,
          [],
        ),
        returnValue: _i7.Stream<List<_i3.PeerPALUser>>.empty(),
      ) as _i7.Stream<List<_i3.PeerPALUser>>);
  @override
  _i7.Stream<List<_i3.PeerPALUser>> getFriendRequestsFromUser() =>
      (super.noSuchMethod(
        Invocation.method(
          #getFriendRequestsFromUser,
          [],
        ),
        returnValue: _i7.Stream<List<_i3.PeerPALUser>>.empty(),
      ) as _i7.Stream<List<_i3.PeerPALUser>>);
  @override
  _i7.Stream<int> getFriendRequestsSize() => (super.noSuchMethod(
        Invocation.method(
          #getFriendRequestsSize,
          [],
        ),
        returnValue: _i7.Stream<int>.empty(),
      ) as _i7.Stream<int>);
}

/// A class which mocks [AuthenticationRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationRepository extends _i1.Mock
    implements _i15.AuthenticationRepository {
  MockAuthenticationRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Cache get cache => (super.noSuchMethod(
        Invocation.getter(#cache),
        returnValue: _FakeCache_0(
          this,
          Invocation.getter(#cache),
        ),
      ) as _i2.Cache);
  @override
  _i7.Stream<_i5.AuthUser> get user => (super.noSuchMethod(
        Invocation.getter(#user),
        returnValue: _i7.Stream<_i5.AuthUser>.empty(),
      ) as _i7.Stream<_i5.AuthUser>);
  @override
  _i5.AuthUser get currentUser => (super.noSuchMethod(
        Invocation.getter(#currentUser),
        returnValue: _FakeAuthUser_3(
          this,
          Invocation.getter(#currentUser),
        ),
      ) as _i5.AuthUser);
  @override
  _i7.Future<void> signUp({
    required String? email,
    required String? password,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #signUp,
          [],
          {
            #email: email,
            #password: password,
          },
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> loginWithEmailAndPassword({
    required String? email,
    required String? password,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #loginWithEmailAndPassword,
          [],
          {
            #email: email,
            #password: password,
          },
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<bool> resetPassword({required String? email}) =>
      (super.noSuchMethod(
        Invocation.method(
          #resetPassword,
          [],
          {#email: email},
        ),
        returnValue: _i7.Future<bool>.value(false),
      ) as _i7.Future<bool>);
  @override
  _i7.Future<void> logout() => (super.noSuchMethod(
        Invocation.method(
          #logout,
          [],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
}
