import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peerpal/app_logger.dart';
import 'package:peerpal/chat/data/dtos/chat_dto.dart';
import 'package:peerpal/chat/data/dtos/chat_message_dto.dart';
import 'package:peerpal/chat/domain/message_type.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/repository/contracts/user_database_contract.dart';

class ChatRepositoryFirebase implements ChatRepository {
  /* StreamSubscription<QuerySnapshot<Map<String, dynamic>>> streamSubscription;

    List<Chat> chatList = <Chat>[];
    streamSubscription = chatStream.listen((value) async* {
      chatList.clear();
      value.docs.forEach((document) {
        var documentData = document.data as Map<String, dynamic>;
        var chat = ChatDTO.fromJson(documentData);
        chatList.add(chat);
      });
      yield chatList;
    });
*/

  @override
  Stream<List<Chat>> getChatListForUserId(String currentUserId) async* {
    //ToDo: Implement strategy to dispose firebase stream
    Stream<QuerySnapshot> chatStream = FirebaseFirestore.instance
        .collection(UserDatabaseContract.chat)
        .where(UserDatabaseContract.chatUids, arrayContains: currentUserId)
        .orderBy(UserDatabaseContract.chatTimestamp, descending: true)
        /* .limit(10)*/
        .snapshots();
    logger.i("Chat-Stream created.");

    List<Chat> chatList = <Chat>[];
    await for (QuerySnapshot querySnapshot in chatStream) {
      logger.i("Chat-Change");
      chatList.clear();
      querySnapshot.docs.forEach((document) {
        var documentData = document.data() as Map<String, dynamic>;
        var chat = ChatDTO.fromJson(documentData);
        chatList.add(chat);
      });
      yield chatList;
    }
  }

  Future<void> sendChatMessage(PeerPALUser userInformation, String? chatId,
      String message, MessageType type) async {
    String? currentUserId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('chatNotifications').doc().set({
      'chatId': chatId,
      'message': message,
      'fromId': currentUserId,
      'toId': userInformation.id,
      'type': type.toUIString,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  Future<void> sendChatRequestResponse(String currentUserId,
      String chatPartnerId, bool response, String chatId) async {
    await FirebaseFirestore.instance
        .collection('chatRequestResponse')
        .doc()
        .set({
      'chatId': chatId,
      'response': response,
      'fromId': currentUserId,
      'toId': chatPartnerId,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  Stream<int> messageCountForChat(chatId) async* {
    await for (var messageList in getChatMessagesForChat(chatId)) {
      yield messageList.length;
    }
  }

  Stream<List<ChatMessage>> getChatMessagesForChat(chatId) async* {
    String? currentUserId = FirebaseAuth.instance.currentUser!.uid;

    Stream<QuerySnapshot> messageStream = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('uids', arrayContains: currentUserId)
        .orderBy('timestamp', descending: true)
        .limit(40) // ToDo: Remove limitation
        .snapshots();

    List<ChatMessage> chatList = <ChatMessage>[];
    await for (QuerySnapshot querySnapshot in messageStream) {
      chatList.clear();
      querySnapshot.docs.forEach((document) {
        var documentData = document.data() as Map<String, dynamic>;
        var chat = ChatMessageDTO.fromJson(documentData);
        chatList.add(chat);
      });
      yield chatList;
    }
  }
}
