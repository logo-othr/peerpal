import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peerpal/app/data/firestore/firestore_service.dart';
import 'package:peerpal/app/data/user_database_contract.dart';
import 'package:peerpal/app/domain/core/cache.dart';
import 'package:peerpal/discover_feed/data/dto/peerpal_user_dto.dart';
import 'package:peerpal/discover_feed/data/dto/private_user_information_dto.dart';
import 'package:peerpal/discover_feed/data/dto/public_user_information_dto.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

import '../../../app_logger.dart';

class AppUserRepository {
  AppUserRepository(
      {required Cache cache, required FirestoreService firestoreService})
      : _cache = cache,
        this._service = firestoreService;

  final Cache _cache;
  final FirestoreService _service;
  final userCacheString = 'userinformation';

  Future<void> updateUser(PeerPALUser updateUser) async {
    final uid = updateUser.id;

    // Nullcheck
    if (uid == null) return; // ToDo: Throw exception

    // Fetching document references.
    final publicDocRef =
        _service.getDocument(UserDatabaseContract.publicUsers, uid);
    final privateDocRef =
        _service.getDocument(UserDatabaseContract.privateUsers, uid);

    // Convert domain object to DTO and cache.
    final PeerPALUserDTO userDTO = PeerPALUserDTO.fromDomainObject(updateUser);
    _storeUserInCache(uid, userDTO);

    // Serializing DTO to JSON.
    final publicUserJson = userDTO.publicUserInformation?.toJson();
    final privateUserJson = userDTO.privateUserInformation?.toJson();

    // Nullcheck
    if (publicUserJson == null || privateUserJson == null) {
      return; // TODO: Throw exception
    }

    // Setting data in Firestore.
    await _service.setDocumentData(publicDocRef, publicUserJson);
    await _service.setDocumentData(privateDocRef, privateUserJson);

    _updateServerNameCache(userDTO.publicUserInformation?.name);
  }

  Future<PeerPALUser> getUser(String uid) async {
    var userDTO = await _downloadUserInformation(uid);
    _storeUserInCache(uid, userDTO);
    var user = userDTO.toDomainObject();
    return user;
  }

  Future<List<PeerPALUser>> findUserByName(String userName,
      {List<String> ignoreList = const []}) async {
    QuerySnapshot<Map<String, dynamic>> userSnapshots = await _service
        .collection(UserDatabaseContract.publicUsers)
        .where(UserDatabaseContract.userName, isEqualTo: userName)
        .get();

    List<PeerPALUser> userList = <PeerPALUser>[];

    userSnapshots.docs.forEach((document) {
      Map<String, dynamic> documentData = document.data();
      var publicUserDTO = PublicUserInformationDTO.fromJson(documentData);
      var peerPALUserDTO = PeerPALUserDTO(publicUserInformation: publicUserDTO);
      var publicUser = peerPALUserDTO.toDomainObject();
      if (!ignoreList.contains(publicUser.id))
        userList.add(publicUser); // ToDo: Test.
    });

    return userList;
  }

  Future<PeerPALUser> getAppUser() async {
    firebase_auth.User? firebaseUser =
        firebase_auth.FirebaseAuth.instance.currentUser;
    String uid = firebaseUser!.uid;

    PeerPALUser userInformation = PeerPALUser.empty;

    PeerPALUserDTO? cachedUserDTO =
        _cache.retrieve<PeerPALUserDTO>(key: '$uid-$userCacheString');

    if (cachedUserDTO != null) {
      userInformation = cachedUserDTO.toDomainObject();
    } else {
      PeerPALUserDTO downloadedUserDTO = await _downloadUserInformation(uid);

      _cache.store<PeerPALUserDTO>(
          key: '$uid-$userCacheString', value: downloadedUserDTO);
      userInformation = downloadedUserDTO.toDomainObject();
    }
    return userInformation;
  }

  // ToDo: Move to cache service
  void _storeUserInCache(String uid, PeerPALUserDTO userDTO) {
    _cache.store<PeerPALUserDTO>(key: '$uid-$userCacheString', value: userDTO);
  }

  Future<void> _updateServerNameCache(String? userName) async {
    if (userName == null) return; //TODO: Throw error
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection(UserDatabaseContract.updateName)
        .doc()
        .set({
      UserDatabaseContract.userId: currentUserId,
      UserDatabaseContract.userName: userName
    });
  }

  Future<PeerPALUserDTO> _downloadUserInformation(String uid) async {
    var peerPALUserDTO = PeerPALUserDTO.empty;
    var publicUserDataDTO;
    var privateUserDataDTO;

    var publicUserDocument = await _service
        .collection(UserDatabaseContract.publicUsers)
        .doc(uid)
        .get();

    var privateUserDocument = null;
    try {
      privateUserDocument = await _service
          .collection(UserDatabaseContract.privateUsers)
          .doc(uid)
          .get();
    } on Exception catch (e) {
      logger.i('$e'); // ToDo: Use firebase error codes
      logger.i(e);
    }

    if (publicUserDocument.exists && publicUserDocument.data() != null) {
      var publicUserData = publicUserDocument.data();
      publicUserDataDTO = PublicUserInformationDTO.fromJson(publicUserData!);
    }
    if (privateUserDocument != null &&
        privateUserDocument.exists &&
        privateUserDocument.data() != null) {
      var privateUserData = privateUserDocument.data();
      privateUserDataDTO = PrivateUserInformationDTO.fromJson(privateUserData!);
    }
    peerPALUserDTO = PeerPALUserDTO(
        privateUserInformation: privateUserDataDTO ?? null,
        publicUserInformation: publicUserDataDTO);
    return peerPALUserDTO;
  }
}
