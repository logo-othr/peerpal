import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peerpal/app/data/firestore/firestore_service.dart';
import 'package:peerpal/app_logger.dart';
import 'package:peerpal/authentication/domain/auth_service.dart';
import 'package:peerpal/chat/data/dtos/chat_dto.dart';
import 'package:peerpal/chat/data/dtos/chat_message_dto.dart';
import 'package:peerpal/chat/domain/message_type.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/repository/contracts/user_database_contract.dart';

class ChatRepositoryFirebase implements ChatRepository {
  final FirestoreService _firestoreService;
  final AuthService _authService;

  final String _chatNotificationsCollection = 'chatNotifications';
  final String _chatRequestResponseCollection = 'chatRequestResponse';
  final String _chatsCollection = 'chats';
  final String _messagesSubCollection = 'messages';
  final String _timestampField = 'timestamp';
  final String _uidsField = 'uids';

  ChatRepositoryFirebase({
    required FirestoreService firestoreService,
    required AuthService authService,
  })  : _firestoreService = firestoreService,
        _authService = authService;

  String _currentTimestamp() =>
      DateTime.now().millisecondsSinceEpoch.toString();

  Stream<List<Chat>> getChatListForUserId() async* {
    String currentUserId = await _authService.getCurrentUserId();
    Stream<QuerySnapshot> chatStream = _firestoreService
        .collection(UserDatabaseContract.chat)
        .where(UserDatabaseContract.chatUids, arrayContains: currentUserId)
        .orderBy(UserDatabaseContract.chatTimestamp, descending: true)
        .snapshots();
    logger.i("Chat-Stream created.");

    yield* _firestoreService.convertSnapshotStreamToModelListStream(
        chatStream, (jsonData) => ChatDTO.fromJson(jsonData));
  }

  Future<void> sendChatMessage(PeerPALUser userInformation, String? chatId,
      String message, MessageType type) async {
    String currentUserId = await _authService.getCurrentUserId();
    await _firestoreService.setDocument(
        collection: _chatNotificationsCollection,
        docId: null,
        data: {
          'chatId': chatId,
          'message': message,
          'fromId': currentUserId,
          'toId': userInformation.id,
          'type': type.toUIString,
          'timestamp': _currentTimestamp(),
        });
  }

  Future<void> sendChatRequestResponse(
      String chatPartnerId, bool response, String chatId) async {
    String currentUserId = await _authService.getCurrentUserId();
    await _firestoreService.setDocument(
        collection: _chatRequestResponseCollection,
        docId: null,
        data: {
          'chatId': chatId,
          'response': response,
          'fromId': currentUserId,
          'toId': chatPartnerId,
          'timestamp': _currentTimestamp(),
        });
  }

  Stream<int> messageCountForChat(String chatId) async* {
    String currentUserId = await _authService.getCurrentUserId();
    await for (var messageList in getChatMessagesForChat(chatId)) {
      yield messageList.length;
    }
  }

  Stream<List<ChatMessage>> getChatMessagesForChat(String chatId) async* {
    String currentUserId = await _authService.getCurrentUserId();
    Stream<QuerySnapshot> messageStream = _firestoreService
        .collection(_chatsCollection)
        .doc(chatId)
        .collection(_messagesSubCollection)
        .where(_uidsField, arrayContains: currentUserId)
        .orderBy(_timestampField, descending: true)
        .limit(40)
        .snapshots();

    yield* _firestoreService.convertSnapshotStreamToModelListStream(
        messageStream, (jsonData) => ChatMessageDTO.fromJson(jsonData));
  }
}
