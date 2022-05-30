import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:peerpal/repository/cache.dart';
import 'package:peerpal/repository/contracts/user_database_contract.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/repository/models/auth_user.dart';
import 'package:peerpal/repository/models/enum/communication_type.dart';
import 'package:peerpal/repository/models/location.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';
import 'package:peerpal/repository/models/peerpal_user_dto.dart';
import 'package:peerpal/repository/models/private_user_information_dto.dart';
import 'package:peerpal/repository/models/public_user_information_dto.dart';


class AppUserRepository {
  AppUserRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    required this.cache,
  })
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        currentUserId = firebase_auth.FirebaseAuth.instance.currentUser!.uid;


  final Cache cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUserId;


  Future<void> updateUserInformation(PeerPALUser peerPALUser,
      {String? id}) async {
    firebase_auth.FirebaseAuth.instance.currentUser!.uid;


    var uid = id == null ? currentUserId : id;
    peerPALUser = peerPALUser.copyWith(id: uid);
    var publicUserCollection =
    _firestore.collection(UserDatabaseContract.publicUsers).doc(uid);
    var privateUserCollection =
    _firestore.collection(UserDatabaseContract.privateUsers).doc(uid);

    var userDTO = PeerPALUserDTO.fromDomainObject(peerPALUser);

    cache.set<PeerPALUserDTO>(
        key: '{$currentUserId}-userinformation', value: userDTO);

    var publicUserInformationJson = userDTO.publicUserInformation?.toJson();
    var privateUserInformation = userDTO.privateUserInformation?.toJson();

    if (publicUserInformationJson != null)
      await publicUserCollection.set(
          publicUserInformationJson, SetOptions(merge: true));
    if (privateUserInformation != null)
      await privateUserCollection.set(
          privateUserInformation, SetOptions(merge: true));
  }

  Future<PeerPALUserDTO> _downloadCurrentUserInformation() async {
    var firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
    var uid = firebaseUser!.uid;
    return await _downloadUserInformation(uid);
  }

  Future<PeerPALUser> getUserInformation(String uid) async {
    return (await _downloadUserInformation(uid)).toDomainObject();
  }

  Future<List<PeerPALUser>> getUserForName(String name) async {
    QuerySnapshot<Map<String, dynamic>> userSnapshots = await _firestore
        .collection(UserDatabaseContract.publicUsers)
        .where('name', isEqualTo: name)
        .get();

    List<PeerPALUser> userList = <PeerPALUser>[];

    userSnapshots.docs.forEach((document) {
      var documentData = document.data();
      var publicUserDTO = PublicUserInformationDTO.fromJson(documentData);
      var peerPALUserDTO = PeerPALUserDTO(publicUserInformation: publicUserDTO);
      var publicUser = peerPALUserDTO.toDomainObject();
      if (publicUser.id != currentUserId) userList.add(publicUser);
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
    if (privateUserDocument != null && privateUserDocument.exists &&
        privateUserDocument.data() != null) {
      var privateUserData = privateUserDocument.data();
      privateUserDataDTO = PrivateUserInformationDTO.fromJson(privateUserData!);
    }
    peerPALUserDTO = PeerPALUserDTO(
        privateUserInformation: privateUserDataDTO ?? null,
        publicUserInformation: publicUserDataDTO);
    return peerPALUserDTO;
  }

  Query<Map<String, dynamic>> _buildGetMatchingUsersQuery(
      {required PeerPALUser? lastUser,
        required int limit,
        required CollectionReference<Map<String, dynamic>> collection,
        required PeerPALUser currentUser}) {
    var query = collection
        .where(UserDatabaseContract.userAge,
        isGreaterThanOrEqualTo: currentUser.discoverFromAge)
        .where(UserDatabaseContract.userAge,
        isLessThanOrEqualTo: currentUser.discoverToAge);

    if (currentUser.discoverLocations != null &&
        currentUser.discoverLocations!.isNotEmpty)
      query = query.where(UserDatabaseContract.discoverLocations,
          arrayContainsAny:
          currentUser.discoverLocations!.map((e) => e.place).toList());

/*
 PeerPALUserDTO userDTO = PeerPALUserDTO.fromDomainObject(currentUser);
    query = query.where('combined_location_activities',
        arrayContainsAny:
        userDTO.publicUserInformation?.combined_location_activities);
 */

    //['Köln', 'Berlin', 'Mainz', 'Regensburg']); //
    /* if(currentUser.discoverActivitiesCodes != null && currentUser.discoverActivitiesCodes!.isNotEmpty && currentUser.discoverActivitiesCodes!.length <= 10) {
      query = query.where(UserDatabaseContract.discoverActivities,
          arrayContainsAny:
          currentUser.discoverActivitiesCodes);
    }*/

    /*  query = query.where(UserDatabaseContract.phonePreference,
        isEqualTo: /*currentUser.discoverCommunicationPreferences!
            .contains(CommunicationType.phone)*/
            true);

    query = query.where(UserDatabaseContract.chatPreference,
        isEqualTo: /*currentUser.discoverCommunicationPreferences!
            .contains(CommunicationType.chat)*/
            true);*/

    query = query
        .orderBy(UserDatabaseContract.userAge)
        .orderBy(UserDatabaseContract.userName)
        .orderBy(UserDatabaseContract.uid);

    if (lastUser != null)
      query = query.startAfter([lastUser.age, lastUser.name, lastUser.id]);

    query = query.limit(limit);
    return query;
  }

  // ToDo: Remove limit
  Stream<List<PeerPALUser>> getMatchingUsersStream({int limit = 100}) async* {
    var currentPeerPALUser = await getCurrentUserInformation();

    var publicUserCollection =
    await _firestore.collection(UserDatabaseContract.publicUsers);

    var query = _buildGetMatchingUsersQuery(
        lastUser: null,
        limit: limit,
        collection: publicUserCollection,
        currentUser: currentPeerPALUser);

    var snapshots = await query.snapshots();
    List<PeerPALUser> userList = <PeerPALUser>[];
    await for (QuerySnapshot querySnapshot in snapshots) {
      userList.clear();
      querySnapshot.docs.forEach((document) {
        var documentData = document.data() as Map<String, dynamic>;
        var publicUserDTO = PublicUserInformationDTO.fromJson(documentData);
        var peerPALUserDTO =
        PeerPALUserDTO(publicUserInformation: publicUserDTO);
        var publicUser = peerPALUserDTO.toDomainObject();
        if (publicUser.id != currentUserId) userList.add(publicUser);
      });
      yield userList;
    }
  }

  Future<List<PeerPALUser>> getMatchingUsers(
      {PeerPALUser? last = null, required int limit}) async {
    var currentPeerPALUser = await getCurrentUserInformation();
    if (currentPeerPALUser.discoverLocations != null &&
        currentPeerPALUser.discoverLocations!.isEmpty) return [];

    var publicUserCollection =
    await _firestore.collection(UserDatabaseContract.publicUsers);

    var query = _buildGetMatchingUsersQuery(
        lastUser: last,
        limit: limit,
        collection: publicUserCollection,
        currentUser: currentPeerPALUser);

    var snapshots = await query.get();

    final matchedUserDocuments =
    snapshots.docs.map((doc) => doc.data()).toList();

    var publicUsers = matchedUserDocuments
        .map((e) => PublicUserInformationDTO.fromJson(e))
        .toList();

    var peerPALUserDTOs = publicUsers
        .map((e) => PeerPALUserDTO(publicUserInformation: e))
        .toList();

    // ToDo: filter for activities

    var peerPALUsers = peerPALUserDTOs.map((e) => e.toDomainObject()).toList();
    return peerPALUsers;
  }

  Future<PeerPALUser> getCurrentUserInformation() async {
    var userInformation = PeerPALUser.empty;
    var cachedUserDTO =
    cache.get<PeerPALUserDTO>(key: '{$currentUserId}-userinformation');
    if (cachedUserDTO != null) {
      userInformation = cachedUserDTO.toDomainObject();
    } else {
      var downloadedUserDTO = await _downloadCurrentUserInformation();
      cache.set<PeerPALUserDTO>(
          key: '{$currentUserId}-userinformation', value: downloadedUserDTO);
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

  Stream<List<PeerPALUser>> getFriendRequestsFromUser() {
    return getList('friendRequests');
  }

  Stream<int> getFriendRequestsSize() async* {
    await for (var friendRequestList in getFriendRequestsFromUser()) {
      yield friendRequestList.length;
    }
  }

  Future<void> sendFriendRequestToUser(PeerPALUser userInformation) async {
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('friendRequestNotifications')
        .doc(DateTime
        .now()
        .millisecondsSinceEpoch
        .toString())
        .set({
      'fromId': currentUserId,
      'toId': userInformation.id,
    });
  }

  Future<void> canceledFriendRequest(PeerPALUser userInformation) async {
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('canceledFriendRequests')
        .doc(DateTime
        .now()
        .millisecondsSinceEpoch
        .toString())
        .set({
      'fromId': currentUserId,
      'toId': userInformation.id,
    });
  }

  Future<void> friendRequestResponse(PeerPALUser userInformation,
      bool response) async {
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('friendRequestResponse')
        .doc(DateTime
        .now()
        .millisecondsSinceEpoch
        .toString())
        .set({
      'fromId': currentUserId,
      'toId': userInformation.id,
      'response': response,
    });
  }

  Stream<List<PeerPALUser>> getFriendList() async* {
    var currentList = <PeerPALUser>[];
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;

    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('privateUserData')
        .doc(currentUserId)
        .collection('friends')
        .snapshots();

    await for (QuerySnapshot querySnapshot in stream) {
      currentList.clear();
      for (var doc in querySnapshot.docs) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('publicUserData')
            .doc(doc.id)
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

  Stream<List<PeerPALUser>> getSentFriendRequestsFromUser() {
    return getList('sentFriendRequests');
  }

  Stream<List<PeerPALUser>> getList(String listName) async* {
    var currentList = <PeerPALUser>[];
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;

    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('privateUserData')
        .doc(currentUserId)
        .collection(listName)
        .snapshots();

    await for (QuerySnapshot querySnapshot in stream) {
      currentList.clear();
      for (var doc in querySnapshot.docs) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('publicUserData')
            .doc(doc.id)
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

//----------------------------------------------------
//Friends End
//----------------------------------------------------

}
