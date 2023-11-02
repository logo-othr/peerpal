import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:peerpal/app/data/firestore/firestore_service.dart';
import 'package:peerpal/app/data/location/dto/location.dart';
import 'package:peerpal/app/data/user_database_contract.dart';
import 'package:peerpal/app/domain/core/cache.dart';
import 'package:peerpal/discover_feed/data/dto/peerpal_user_dto.dart';
import 'package:peerpal/discover_feed/data/dto/private_user_information_dto.dart';
import 'package:peerpal/discover_feed/data/dto/public_user_information_dto.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/enum/communication_type.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app_logger.dart';

class AppUserRepository {
  AppUserRepository(
      {firebase_auth.FirebaseAuth? firebaseAuth,
      required this.cache,
      required FirestoreService firestoreService})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        this._firestoreService = firestoreService;

  final Cache cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreService _firestoreService;

  Future<void> updateUser(PeerPALUser peerPALUser) async {
    final uid = peerPALUser.id;

    // Nullcheck
    if (uid == null) return; // ToDo: Throw exception

    // Fetching document references.
    final DocumentReference<Object?> publicDocRef =
        _firestoreService.getDocument(UserDatabaseContract.publicUsers, uid);
    final DocumentReference<Object?> privateDocRef =
        _firestoreService.getDocument(UserDatabaseContract.privateUsers, uid);

    // Convert domain object to DTO and cache.
    final PeerPALUserDTO userDTO = PeerPALUserDTO.fromDomainObject(peerPALUser);
    _storeUserInCache(uid, userDTO);

    // Serializing DTO to JSON.
    final Map<String, dynamic>? publicUserInfo =
        userDTO.publicUserInformation?.toJson();
    final Map<String, dynamic>? privateUserInfo =
        userDTO.privateUserInformation?.toJson();

    // Nullcheck
    if (publicUserInfo == null || privateUserInfo == null) {
      return; // ToDo: Throw exception
    }

    // Setting data in Firestore.
    await _firestoreService.setDocumentData(publicDocRef, publicUserInfo);
    await _firestoreService.setDocumentData(privateDocRef, privateUserInfo);
  }

  // ToDo: Move to cache service
  void _storeUserInCache(String uid, PeerPALUserDTO userDTO) {
    cache.store<PeerPALUserDTO>(key: '{$uid}-userinformation', value: userDTO);
  }

  Future<void> updateServerNameCache(userName) async {
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('updateNameAtServer')
        .doc()
        .set({'userId': currentUserId, 'name': userName});
  }

  Future<PeerPALUser> getUser(String uid) async {
    return (await _downloadUserInformation(uid)).toDomainObject();
  }

  Future<List<PeerPALUser>> findUserByName(String userName,
      {List<String> ignoreList = const []}) async {
    QuerySnapshot<Map<String, dynamic>> userSnapshots = await _firestore
        .collection(UserDatabaseContract.publicUsers)
        .where('name', isEqualTo: userName)
        .get();

    List<PeerPALUser> userList = <PeerPALUser>[];

    userSnapshots.docs.forEach((document) {
      var documentData = document.data();
      var publicUserDTO = PublicUserInformationDTO.fromJson(documentData);
      var peerPALUserDTO = PeerPALUserDTO(publicUserInformation: publicUserDTO);
      var publicUser = peerPALUserDTO.toDomainObject();
      if (!ignoreList.contains(publicUser.id))
        userList.add(publicUser); // ToDo: Test.
    });

    return userList;
  }

  Future<PeerPALUserDTO> _downloadUserInformation(String uid) async {
    var peerPALUserDTO = PeerPALUserDTO.empty;
    var publicUserDataDTO;
    var privateUserDataDTO;

    var publicUserDocument = await _firestore
        .collection(UserDatabaseContract.publicUsers)
        .doc(uid)
        .get();

    var privateUserDocument = null;
    try {
      privateUserDocument = await _firestore
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

  Future<BehaviorSubject<List<PeerPALUser>>> findPeers(
      String authenticatedUserId) async {
    var currentPeerPALUser = await getCachedAppUser();

    // Check if any discovery settings are empty and return an empty BehaviorSubject if true.
    if (isDiscoverySettingsEmpty(currentPeerPALUser)) return BehaviorSubject();

    // Build and run location and activity queries.
    Stream<QuerySnapshot<Map<String, dynamic>>> locationStream =
        buildAndRunQuery(
            currentPeerPALUser.discoverLocations!.map((e) => e.place).toList(),
            UserDatabaseContract.discoverLocations);
    Stream<QuerySnapshot<Map<String, dynamic>>> activityStream =
        buildAndRunQuery(
            currentPeerPALUser.discoverActivitiesCodes!.map((e) => e).toList(),
            UserDatabaseContract.discoverActivities);

    // Combine both streams to generate a list of unique matched PeerPALUsers.
    Stream<List<PeerPALUser>> combinedFilteredUserStream =
        combineLocationAndActivityStreams(locationStream, activityStream);

    BehaviorSubject<List<PeerPALUser>> combinedFilteredUserStreamController =
        BehaviorSubject();
    combinedFilteredUserStreamController.addStream(combinedFilteredUserStream);

    return combinedFilteredUserStreamController;
  }

  bool isDiscoverySettingsEmpty(PeerPALUser user) {
    return user.discoverActivitiesCodes == null ||
        user.discoverActivitiesCodes!.isEmpty ||
        user.discoverLocations == null ||
        user.discoverLocations!.isEmpty;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> buildAndRunQuery(
      List<dynamic> filterValues, String fieldName) {
    // Apply query filters and sorting criteria.
    Query<Map<String, dynamic>> query = _firestore
        .collection(UserDatabaseContract.publicUsers)
        .where(fieldName, arrayContainsAny: filterValues)
        .orderBy(UserDatabaseContract.userAge)
        .orderBy(UserDatabaseContract.userName)
        .orderBy(UserDatabaseContract.uid);

    // Convert the query to a stream.
    return query.snapshots();
  }

  Stream<List<PeerPALUser>> combineLocationAndActivityStreams(
      Stream<QuerySnapshot<Map<String, dynamic>>> locationStream,
      Stream<QuerySnapshot<Map<String, dynamic>>> activityStream) {
    return Rx.combineLatest2(locationStream, activityStream,
        (QuerySnapshot<Map<String, dynamic>> matchedByLocationDocuments,
            QuerySnapshot<Map<String, dynamic>> matchedByActivityDocuments) {
      List<PeerPALUser> matchedByLocationUsers =
          convertQueryToPeerPALUsers(matchedByLocationDocuments);
      List<PeerPALUser> matchedByActivityUsers =
          convertQueryToPeerPALUsers(matchedByActivityDocuments);

      // Combine and shuffle unique users.
      List<PeerPALUser> uniqueUsers = combineAndFilterUniqueUsers(
          matchedByLocationUsers, matchedByActivityUsers);

      return uniqueUsers;
    });
  }

  List<PeerPALUser> convertQueryToPeerPALUsers(
      QuerySnapshot<Map<String, dynamic>> query) {
    return query.docs
        .map((document) => convertDocumentSnapshotToPeerPALUser(document))
        .where((user) => user != null)
        .cast<PeerPALUser>()
        .toList();
  }

  List<PeerPALUser> combineAndFilterUniqueUsers(
      List<PeerPALUser> locationUsers, List<PeerPALUser> activityUsers) {
    List<PeerPALUser> combinedUsers = List.from(locationUsers)
      ..addAll(activityUsers);

    final seenIds = Set<String>();
    List<PeerPALUser> uniqueUsers =
        combinedUsers.where((user) => seenIds.add(user.id!)).toList();

    uniqueUsers.shuffle();
    return uniqueUsers;
  }

  PeerPALUser? convertDocumentSnapshotToPeerPALUser(DocumentSnapshot document) {
    var documentData = document.data() as Map<String, dynamic>;
    var publicUserDTO = PublicUserInformationDTO.fromJson(documentData);
    var peerPALUserDTO = PeerPALUserDTO(publicUserInformation: publicUserDTO);
    PeerPALUser publicUser = peerPALUserDTO.toDomainObject();
    if (publicUser.id != _firebaseAuth.currentUser?.uid) return publicUser;
    return null;
  }

  Future<PeerPALUser> getCachedAppUser() async {
    firebase_auth.User? firebaseUser =
        firebase_auth.FirebaseAuth.instance.currentUser;
    String uid = firebaseUser!.uid;

    PeerPALUser userInformation = PeerPALUser.empty;
    PeerPALUserDTO? cachedUserDTO =
        cache.retrieve<PeerPALUserDTO>(key: '{$uid}-userinformation');
    if (cachedUserDTO != null) {
      userInformation = cachedUserDTO.toDomainObject();
    } else {
      PeerPALUserDTO downloadedUserDTO = await _downloadUserInformation(uid);

      cache.store<PeerPALUserDTO>(
          key: '{$uid}-userinformation', value: downloadedUserDTO);
      userInformation = downloadedUserDTO.toDomainObject();
    }
    return userInformation;
  }

  List<CommunicationType> loadCommunicationList() {
    final communicationTypes = <CommunicationType>[];
    communicationTypes.add(CommunicationType.phone);
    communicationTypes.add(CommunicationType.chat);
    return communicationTypes;
  }

  Future<List<Location>> loadLocations() async {
    final jsonData = await rootBundle.loadString('assets/location.json');
    final list = json.decode(jsonData) as List<dynamic>;
    return list.map((e) => Location.fromJson(e)).toList();
  }

  //----------------------------------------------------
  //Friends Start
  //----------------------------------------------------















//----------------------------------------------------
//Friends End
//----------------------------------------------------
}
