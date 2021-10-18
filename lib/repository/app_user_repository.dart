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

class SignUpFailure implements Exception {
  SignUpFailure({this.message = 'Fehler bei der Registierung'});

  final String message;
}

class LoginException implements Exception {
  LoginException({this.message = 'Fehler beim Login.'});

  final String message;
}

class LogoutException implements Exception {
  LogoutException({this.message = 'Fehler beim Ausloggen.'});

  final String message;
}

class AppUserRepository {
  AppUserRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    required this.cache,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final Cache cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<AuthUser> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? AuthUser.empty : _getUserFromFirebaseUser();
    });
  }

  // ToDo: Remove if not used in the future
  Stream<PeerPALUser> get userInformation {
    return _firestore
        .collection(UserDatabaseContract.users)
        .doc(currentUser.id)
        .snapshots()
        .map((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        int age = snapshot['age'];
        var name = snapshot['name'];
        return PeerPALUser(age: age, name: name);
      } else {
        return PeerPALUser.empty;
      }
    });
  }

  AuthUser get currentUser {
    return _getUserFromFirebaseUser();
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html
      switch (e.code) {
        case 'email-already-in-use':
          throw SignUpFailure(
              message: "Diese E-Mail ist bereits in Benutzung.");
        case 'operation-not-allowed':
          throw SignUpFailure(
              message: 'Es ist ein Fehler aufgetreten. '
                  'Registierungen sind deaktiviert.');
        case 'weak-password:':
          throw SignUpFailure(message: 'Das gewählte Passwort ist zu schwach.');
        case 'too-many-requests':
          throw SignUpFailure(
              message: 'Der Server ist ausgelastet. Bitte versuche es später '
                  'oder morgen noch einmal.');
        default:
          throw SignUpFailure();
      }
    } on Exception {
      throw SignUpFailure();
    }
  }

  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // error-codes: https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithEmailAndPassword.html
      switch (e.code) {
        case 'wrong-password':
        case 'user-not-found':
          throw LoginException(
              message:
                  'Falsches Passwort oder die der Nutzer existiert nicht.');
        case 'user-disabled':
          throw LoginException(message: 'Der Account wurde deaktiviert.');
        case 'invalid-email':
          throw LoginException(message: 'Die E-Mail ist ungültig.');
        case 'too-many-requests':
          throw LoginException(
              message:
                  'Der Server ist ausgelastet. Bitte versuche es später oder '
                  "morgen noch einmal.");
        default:
          throw LoginException();
      }
    } on Exception {
      throw LoginException();
    }
  }

  Future<void> logout() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } on Exception {
      throw LogoutException();
    }
  }

  Future<void> updateUserInformation(PeerPALUser userInformation) async {
    var userDocument =
        _firestore.collection(UserDatabaseContract.users).doc(currentUser.id);

    cache.set<PeerPALUser>(
        key: '{$currentUser.uid}-userinformation', value: userInformation);

    var json = userInformation.toJson();

    await userDocument.set(json, SetOptions(merge: true));
  }

  Future<PeerPALUser> _downloadCurrentUserInformation() async {
    var firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

    var userInformation = PeerPALUser.empty;
    var userDocumentSnapshot = await _firestore
        .collection(UserDatabaseContract.users)
        .doc(firebaseUser!.uid)
        .get();
    if (userDocumentSnapshot.exists && userDocumentSnapshot.data() != null) {
      var data = userDocumentSnapshot.data();
      userInformation = PeerPALUser.fromJson(data!);
    }
    return userInformation;
  }

  Future<PeerPALUser> getCurrentUserInformation() async {
    var userInformation = PeerPALUser.empty;
    var cachedUserInformation =
        cache.get<PeerPALUser>(key: '{$currentUser.uid}-userinformation');
    if (cachedUserInformation != null) {
      userInformation = cachedUserInformation;
    } else {
      userInformation = await _downloadCurrentUserInformation();
      cache.set<PeerPALUser>(
          key: '{$currentUser.uid}-userinformation', value: userInformation);
    }
    return userInformation;
  }

  AuthUser _getUserFromFirebaseUser() {
    var firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

    return (firebaseUser == null
        ? AuthUser.empty
        : AuthUser(id: firebaseUser.uid, email: firebaseUser.email));
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
}
