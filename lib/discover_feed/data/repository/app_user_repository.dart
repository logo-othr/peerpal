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
import 'package:rxdart/rxdart.dart';

import '../../../app_logger.dart';

class AppUserRepository {
  AppUserRepository(
      {firebase_auth.FirebaseAuth? firebaseAuth,
      required Cache cache,
      required FirestoreService firestoreService})
      : _cache = cache,
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        this._firestoreService = firestoreService;

  final Cache _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreService _firestoreService;
  final userCacheString = 'userinformation';

  Future<void> updateUser(PeerPALUser updateUser) async {
    final uid = updateUser.id;

    // Nullcheck
    if (uid == null) return; // ToDo: Throw exception

    // Fetching document references.
    final DocumentReference<Object?> publicDocRef =
        _firestoreService.getDocument(UserDatabaseContract.publicUsers, uid);
    final DocumentReference<Object?> privateDocRef =
        _firestoreService.getDocument(UserDatabaseContract.privateUsers, uid);

    // Convert domain object to DTO and cache.
    final PeerPALUserDTO userDTO = PeerPALUserDTO.fromDomainObject(updateUser);
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

    _updateServerNameCache(userDTO.publicUserInformation?.name);
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

  Future<PeerPALUser> getUser(String uid) async {
    var userDTO = await _downloadUserInformation(uid);
    _storeUserInCache(uid, userDTO);
    var user = userDTO.toDomainObject();
    return user;
  }

  Future<List<PeerPALUser>> findUserByName(String userName,
      {List<String> ignoreList = const []}) async {
    QuerySnapshot<Map<String, dynamic>> userSnapshots = await _firestore
        .collection(UserDatabaseContract.publicUsers)
        .where(UserDatabaseContract.userName, isEqualTo: userName)
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

  Future<BehaviorSubject<List<PeerPALUser>>> discoverPeers(
      String authenticatedUserId) async {
    var appUser = await getAppUser();

    // Check if any discovery settings are empty and return an empty BehaviorSubject if true.
    if (isDiscoverySettingsEmpty(appUser)) return BehaviorSubject();

    // Build and run location and activity queries.
    Stream<QuerySnapshot<Map<String, dynamic>>> locationStream = _getUsers(
      whereFieldName: UserDatabaseContract.discoverLocations,
      arrayContainsAny: appUser.discoverLocations!.map((e) => e.place).toList(),
    );
    Stream<QuerySnapshot<Map<String, dynamic>>> activityStream = _getUsers(
      whereFieldName: UserDatabaseContract.discoverActivities,
      arrayContainsAny: appUser.discoverActivitiesCodes!.map((e) => e).toList(),
    );

    // Combine both streams to generate a list of unique matched PeerPALUsers.
    Stream<List<PeerPALUser>> combinedFilteredUserStream =
        _combineLocationAndActivityStreams(locationStream, activityStream);

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
    print("STORE_CACHE_PRINT" + _cache.toString());
    print("STORE_USER_CACHED" + userDTO.toString());
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

    /*
     var publicUserDocument = _firestoreService.getDocument(
        UserDatabaseContract.publicUsers, uid);

    var privateUserDocument = null;

    try {
      privateUserDocument = _firestoreService.getDocument(
          UserDatabaseContract.privateUsers, uid);
    } on Exception catch (e) {
      logger.i('$e'); // ToDo: Use firebase error codes
    }*/

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

  Stream<QuerySnapshot<Map<String, dynamic>>> _getUsers(
      {required List<dynamic> arrayContainsAny,
      required String whereFieldName}) {
    // Apply query filters and sorting criteria.
    Query<Map<String, dynamic>> query = _firestore
        .collection(UserDatabaseContract.publicUsers)
        .where(whereFieldName, arrayContainsAny: arrayContainsAny)
        .orderBy(UserDatabaseContract.userAge)
        .orderBy(UserDatabaseContract.userName)
        .orderBy(UserDatabaseContract.uid);

    // Convert the query to a stream.
    return query.snapshots();
  }

  Stream<List<PeerPALUser>> _combineLocationAndActivityStreams(
      Stream<QuerySnapshot<Map<String, dynamic>>> locationStream,
      Stream<QuerySnapshot<Map<String, dynamic>>> activityStream) {
    return Rx.combineLatest2(locationStream, activityStream,
            (QuerySnapshot<Map<String, dynamic>> matchedByLocationDocuments,
            QuerySnapshot<Map<String, dynamic>> matchedByActivityDocuments) {
          List<PeerPALUser> matchedByLocationUsers =
          _queryUsers(matchedByLocationDocuments);
      List<PeerPALUser> matchedByActivityUsers =
          _queryUsers(matchedByActivityDocuments);

      // Combine and shuffle unique users.
      List<PeerPALUser> uniqueUsers =
          _combineLists(matchedByLocationUsers, matchedByActivityUsers);

      uniqueUsers.shuffle();

      return uniqueUsers;
    });
  }

  List<PeerPALUser> _queryUsers(QuerySnapshot<Map<String, dynamic>> query) {
    return query.docs
        .map((document) => _documentToUser(document))
        .where((user) => user != null)
        .cast<PeerPALUser>()
        .toList();
  }

  List<PeerPALUser> _combineLists(
      List<PeerPALUser> locationUsers, List<PeerPALUser> activityUsers) {
    List<PeerPALUser> combinedUsers = List.from(locationUsers)
      ..addAll(activityUsers);

    final seenIds = Set<String>();
    List<PeerPALUser> uniqueUsers =
        combinedUsers.where((user) => seenIds.add(user.id!)).toList();

    uniqueUsers.shuffle();
    return uniqueUsers;
  }

  PeerPALUser? _documentToUser(DocumentSnapshot document) {
    var documentData = document.data() as Map<String, dynamic>;
    var publicUserDTO = PublicUserInformationDTO.fromJson(documentData);
    var peerPALUserDTO = PeerPALUserDTO(publicUserInformation: publicUserDTO);
    PeerPALUser publicUser = peerPALUserDTO.toDomainObject();
    if (publicUser.id != _firebaseAuth.currentUser?.uid) return publicUser;
    return null;
  }
}
