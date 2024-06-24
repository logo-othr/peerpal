import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:peerpal/app/data/firestore/firestore_service.dart';
import 'package:peerpal/app/data/user_database_contract.dart';
import 'package:peerpal/discover_feed/data/dto/peerpal_user_dto.dart';
import 'package:peerpal/discover_feed/data/dto/public_user_information_dto.dart';
import 'package:peerpal/discover_feed/domain/repository/discover_repository.dart';
import 'package:peerpal/discover_feed_v2/domain/peerpal_user.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseDiscoverRepository implements DiscoverRepository {
  FirebaseDiscoverRepository(
      {firebase_auth.FirebaseAuth? firebaseAuth,
      required FirestoreService firestoreService})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        this._firestoreService = firestoreService;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreService _firestoreService;

  Future<BehaviorSubject<List<PeerPALUser>>> discoverPeers(
      PeerPALUser appUser) async {
    // Check if any discovery settings are empty and return an empty BehaviorSubject if true.
    if (_isDiscoverySettingsEmpty(appUser)) return BehaviorSubject();

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

  bool _isDiscoverySettingsEmpty(PeerPALUser user) {
    return user.discoverActivitiesCodes == null ||
        user.discoverActivitiesCodes!.isEmpty ||
        user.discoverLocations == null ||
        user.discoverLocations!.isEmpty;
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
