import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peerpal/app/data/firestore/firestore_service.dart';
import 'package:peerpal/app/data/user_database_contract.dart';
import 'package:peerpal/app_logger.dart';
import 'package:peerpal/authentication/domain/auth_service.dart';
import 'package:peerpal/chat/data/dtos/chat_dto.dart';
import 'package:peerpal/chat/data/dtos/chat_message_dto.dart';
import 'package:peerpal/chat/domain/enums/message_type.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/chat/domain/repositorys/chat_repository.dart';
import 'package:peerpal/firebase_collections.dart';
import 'package:rxdart/rxdart.dart';

class ChatRepositoryFirebase implements ChatRepository {
  final FirestoreService _firestoreService;
  final AuthService _authService;

  final String _timestampField = 'timestamp';
  final String _chatIdField = 'chatId';
  final String _messageField = 'message';
  final String _fromIdField = 'fromId';
  final String _toIdField = 'toId';
  final String _messageTypeField = 'type';
  final String _responseField = 'response';
  final String _uidsField = 'uids';

  final Map<String, BehaviorSubject<List<ChatMessage>>> _messageStreamCache =
      {};

  //ToDo: Remove. Old relict from chatv1

  Stream<List<Chat>> getChats() async* {
    String currentUserId = await _authService.getCurrentUserId();
    Stream<QuerySnapshot> chatStream = _firestoreService
        .collection(UserDatabaseContract.chat)
        .where(UserDatabaseContract.chatUids, arrayContains: currentUserId)
        .orderBy(UserDatabaseContract.chatTimestamp, descending: true)
        .snapshots();
    logger.i("Chat-Stream created.");

    yield* _firestoreService.convertSnapshotStreamToModelListStream(
        chatStream, _fromJsonToChat);
  }

  ChatRepositoryFirebase({
    required FirestoreService firestoreService,
    required AuthService authService,
  })  : _firestoreService = firestoreService,
        _authService = authService;

  String _currentTimestamp() =>
      DateTime.now().millisecondsSinceEpoch.toString();

  @override
  Stream<List<Chat>> chatsStream(String userId) async* {
    Stream<QuerySnapshot> chatStream = _firestoreService
        .collection(UserDatabaseContract.chat)
        .where(UserDatabaseContract.chatUids, arrayContains: userId)
        .orderBy(UserDatabaseContract.chatTimestamp, descending: true)
        .snapshots();
    logger.i("Chat-Stream created.");

    yield* _firestoreService.convertSnapshotStreamToModelListStream(
        chatStream, _fromJsonToChat);
  }

  Chat _fromJsonToChat(Map<String, dynamic> jsonData) {
    return ChatDTO.fromJson(jsonData);
  }

  @override
  Future<void> sendMessage(String senderId, String? chatId, String payload,
      MessageType messageType) async {
    String currentUserId = await _authService.getCurrentUserId();
    await _firestoreService.setDocument(
        collection: FirebaseCollections.chatNotifications,
        docId: null,
        data: {
          _chatIdField: chatId,
          _messageField: payload,
          _fromIdField: currentUserId,
          _toIdField: senderId,
          _messageTypeField: messageType.toUIString,
          _timestampField: _currentTimestamp(),
        });
  }

  @override
  Future<void> sendChatRequestResponse(
      String chatPartnerId, bool response, String chatId) async {
    String currentUserId = await _authService.getCurrentUserId();
    await _firestoreService.setDocument(
        collection: FirebaseCollections.chatRequestResponse,
        docId: null,
        data: {
          _chatIdField: chatId,
          _responseField: response,
          _fromIdField: currentUserId,
          _toIdField: chatPartnerId,
          _timestampField: _currentTimestamp(),
        });
  }

  @override
  Stream<int> messageCountStream(String chatId) async* {
    await for (var messageList in messageStream(chatId)) {
      yield messageList.length;
    }
  }

  @override
  Stream<List<ChatMessage>> messageStream(String chatId) async* {
    String currentUserId = await _authService.getCurrentUserId();
    if (!_messageStreamCache.containsKey(chatId)) {
      Stream<QuerySnapshot> messageStream = _firestoreService
          .collection(FirebaseCollections.chats)
          .doc(chatId)
          .collection(FirebaseCollections.messages)
          .where(_uidsField, arrayContains: currentUserId)
          .orderBy(_timestampField, descending: true)
          .limit(40) // TODO: Remove limit and replace it with pagination
          .snapshots();

      var chatMessageStream =
          _firestoreService.convertSnapshotStreamToModelListStream(
              messageStream, _fromJsonToChatMessage);

      _messageStreamCache[chatId] = BehaviorSubject<List<ChatMessage>>()
        ..addStream(chatMessageStream);
    }

    yield* _messageStreamCache[chatId]!.stream;
  }

  ChatMessage _fromJsonToChatMessage(Map<String, dynamic> jsonData) {
    return ChatMessageDTO.fromJson(jsonData);
  }
}
