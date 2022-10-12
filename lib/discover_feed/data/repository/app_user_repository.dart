import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/data/cache.dart';
import 'package:peerpal/data/location.dart';
import 'package:peerpal/discover_feed/data/dto/peerpal_user_dto.dart';
import 'package:peerpal/discover_feed/data/dto/private_user_information_dto.dart';
import 'package:peerpal/discover_feed/data/dto/public_user_information_dto.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/enum/communication_type.dart';
import 'package:peerpal/repository/contracts/user_database_contract.dart';
import 'package:rxdart/rxdart.dart';

class AppUserRepository {
  AppUserRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    required this.cache,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final Cache cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

/*
  String get currentUserId {
    return _getUserFromFirebaseUser().id;
  }

  AuthUser _getUserFromFirebaseUser() {
    var firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

    return (firebaseUser == null
        ? AuthUser.empty
        : AuthUser(id: firebaseUser.uid, email: firebaseUser.email));
  }

 */

  Future<void> updateUserInformation(PeerPALUser peerPALUser) async {
    var uid = peerPALUser.id;
    var publicUserCollection =
        _firestore.collection(UserDatabaseContract.publicUsers).doc(uid);
    var privateUserCollection =
        _firestore.collection(UserDatabaseContract.privateUsers).doc(uid);

    var userDTO = PeerPALUserDTO.fromDomainObject(peerPALUser);

    cache.set<PeerPALUserDTO>(key: '{$uid}-userinformation', value: userDTO);

    var publicUserInformationJson = userDTO.publicUserInformation?.toJson();
    var privateUserInformation = userDTO.privateUserInformation?.toJson();

    if (publicUserInformationJson != null)
      await publicUserCollection.set(
          publicUserInformationJson, SetOptions(merge: true));
    if (privateUserInformation != null)
      await privateUserCollection.set(
          privateUserInformation, SetOptions(merge: true));
  }

  Future<void> updateNameAtServer(userName) async {
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('updateNameAtServer')
        .doc()
        .set({'userId': currentUserId, 'name': userName});
  }

  Future<PeerPALUserDTO> _downloadCurrentUserInformation() async {
    var firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
    var uid = firebaseUser!.uid;
    return await _downloadUserInformation(uid);
  }

  Future<PeerPALUser> getUserInformation(String uid) async {
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
      print('$e'); // ToDo: Use firebase error codes
      print(e);
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



  Future<BehaviorSubject<List<PeerPALUser>>> getMatchingUsersPaginatedStream(
      String authenticatedUserId,
      {int limit = 4}) async {
    var currentPeerPALUser =
        await getCurrentUserInformation(authenticatedUserId);

    var publicUserCollection =
        await _firestore.collection(UserDatabaseContract.publicUsers);

    Query<Map<String, dynamic>> locationQuery = publicUserCollection.where(
        UserDatabaseContract.discoverLocations,
        arrayContainsAny:
            currentPeerPALUser.discoverLocations!.map((e) => e.place).toList());

    locationQuery = locationQuery
        .orderBy(UserDatabaseContract.userAge)
        .orderBy(UserDatabaseContract.userName)
        .orderBy(UserDatabaseContract.uid);

    Stream<QuerySnapshot<Map<String, dynamic>>> locationStream =
        locationQuery.snapshots();
    BehaviorSubject<QuerySnapshot<Map<String, dynamic>>>
        locationStreamController = new BehaviorSubject();
    locationStreamController.addStream(locationStream);

    Query<Map<String, dynamic>> activitiesQuery = publicUserCollection.where(
        UserDatabaseContract.discoverActivities,
        arrayContainsAny:
            currentPeerPALUser.discoverActivitiesCodes!.map((e) => e).toList());

    activitiesQuery = activitiesQuery
        .orderBy(UserDatabaseContract.userAge)
        .orderBy(UserDatabaseContract.userName)
        .orderBy(UserDatabaseContract.uid);

    Stream<QuerySnapshot<Map<String, dynamic>>> activityStream =
        activitiesQuery.snapshots();
    BehaviorSubject<QuerySnapshot<Map<String, dynamic>>>
        activityStreamController = new BehaviorSubject();
    activityStreamController.addStream(activityStream);

    Stream<List<PeerPALUser>> combinedFilteredUserStream = Rx.combineLatest2(
        locationStreamController.stream, activityStreamController.stream,
        (QuerySnapshot<Map<String, dynamic>> matchedByLocationDocuments,
            QuerySnapshot<Map<String, dynamic>> matchedByActivityDocuments) {
      List<PeerPALUser> matchedByLocationUserList = [];
      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in matchedByLocationDocuments.docs) {
        if (convertDocumentSnapshotToPeerPALUser(document) != null)
          matchedByLocationUserList
              .add(convertDocumentSnapshotToPeerPALUser(document)!);
      }

      List<PeerPALUser> matchedByActivityUserList = [];
      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in matchedByActivityDocuments.docs) {
        if (convertDocumentSnapshotToPeerPALUser(document) != null)
          matchedByActivityUserList
              .add(convertDocumentSnapshotToPeerPALUser(document)!);
      }

      List<PeerPALUser> unfilteredMatchedUsers = []
        ..addAll(matchedByLocationUserList)
        ..addAll(matchedByActivityUserList);

      final temp = Set<String>();
      List<PeerPALUser> uniqueList =
          unfilteredMatchedUsers.where((str) => temp.add(str.id!)).toList();
      uniqueList.shuffle();
      return uniqueList;
    });

    BehaviorSubject<List<PeerPALUser>> combinedFilteredUserStreamController =
        BehaviorSubject();
    combinedFilteredUserStreamController.addStream(combinedFilteredUserStream);
    return combinedFilteredUserStreamController;
  }

  PeerPALUser? convertDocumentSnapshotToPeerPALUser(DocumentSnapshot document) {
    var documentData = document.data() as Map<String, dynamic>;
    var publicUserDTO = PublicUserInformationDTO.fromJson(documentData);
    var peerPALUserDTO = PeerPALUserDTO(publicUserInformation: publicUserDTO);
    PeerPALUser publicUser = peerPALUserDTO.toDomainObject();
    if (publicUser.id != _firebaseAuth.currentUser?.uid) return publicUser;
    return null;
  }

  Future<PeerPALUser> getCurrentUserInformation(String uid) async {
    var userInformation = PeerPALUser.empty;
    var cachedUserDTO =
        cache.get<PeerPALUserDTO>(key: '{$uid}-userinformation');
    if (cachedUserDTO != null) {
      userInformation = cachedUserDTO.toDomainObject();
    } else {
      var downloadedUserDTO = await _downloadCurrentUserInformation();
      cache.set<PeerPALUserDTO>(
          key: '{$uid}-userinformation', value: downloadedUserDTO);
      userInformation = downloadedUserDTO.toDomainObject();
    }
    return userInformation;
  }

  Future<List<Activity>> loadActivityList() async {
    final List<Activity> activities = [];
    activities.add(Activity(code: 'biking', name: "Radfahren"));
    activities.add(Activity(code: 'hiking', name: "Wandern"));
    activities.add(Activity(code: 'soccer', name: "Fußball"));
    activities.add(Activity(code: 'tennis', name: "Tennis"));
    activities.add(Activity(code: 'gardening', name: "Gartenarbeit"));
    activities.add(Activity(code: 'help', name: "Hilfe gesucht"));
    return activities;
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

  Future<void> sendFriendRequestToUser(PeerPALUser userInformation) async {
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('friendRequestNotifications')
        .doc()
        .set({
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'fromId': currentUserId,
      'toId': userInformation.id,
    });
  }

  Future<void> canceledFriendRequest(PeerPALUser userInformation) async {
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('canceledFriendRequests')
        .doc()
        .set({
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'fromId': currentUserId,
      'toId': userInformation.id,
    });
  }

  Future<void> friendRequestResponse(
      PeerPALUser userInformation, bool response) async {
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('friendRequestResponse')
        .doc()
        .set({
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'fromId': currentUserId,
      'toId': userInformation.id,
      'response': response,
    });
  }

  Stream<List<PeerPALUser>> getFriendList() async* {
    var currentList = <PeerPALUser>[];
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;

    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('friends')
        .where('fromId', isEqualTo: currentUserId)
        .snapshots();

    await for (QuerySnapshot querySnapshot in stream) {
      currentList.clear();
      for (var doc in querySnapshot.docs) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('publicUserData')
            .doc(doc['toId'])
            .get();

        var userDTO = PeerPALUserDTO(
            publicUserInformation:
                PublicUserInformationDTO.fromJson(userDoc.data()!));

        PeerPALUser friend = userDTO.toDomainObject();

        if (!currentList.contains(friend)) {
          currentList.add(friend);
        }
      }
      yield currentList;
    }
  }

  Stream<List<PeerPALUser>> getSentFriendRequestsFromUser() async* {
    var currentList = <PeerPALUser>[];
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;

    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('friendRequests')
        .where('fromId', isEqualTo: currentUserId)
        .snapshots();

    await for (QuerySnapshot querySnapshot in stream) {
      currentList.clear();
      for (var doc in querySnapshot.docs) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('publicUserData')
            .doc(doc['toId'])
            .get();

        var userDTO = PeerPALUserDTO(
            publicUserInformation:
                PublicUserInformationDTO.fromJson(userDoc.data()!));

        PeerPALUser friend = userDTO.toDomainObject();

        if (!currentList.contains(friend)) {
          currentList.add(friend);
        }
      }
      yield currentList;
    }
  }

  Stream<List<PeerPALUser>> getFriendRequestsFromUser() async* {
    var currentList = <PeerPALUser>[];
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;

    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('friendRequests')
        .where('toId', isEqualTo: currentUserId)
        .snapshots();

    await for (QuerySnapshot querySnapshot in stream) {
      currentList.clear();
      for (var doc in querySnapshot.docs) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('publicUserData')
            .doc(doc['fromId'])
            .get();

        var userDTO = PeerPALUserDTO(
            publicUserInformation:
                PublicUserInformationDTO.fromJson(userDoc.data()!));

        PeerPALUser friend = userDTO.toDomainObject();

        if (!currentList.contains(friend)) {
          currentList.add(friend);
        }
      }
      yield currentList;
    }
  }

  Stream<int> getFriendRequestsSize() async* {
    await for (var friendRequestList in getFriendRequestsFromUser()) {
      yield friendRequestList.length;
    }
  }

//----------------------------------------------------
//Friends End
//----------------------------------------------------

}
