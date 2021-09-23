import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peerpal/repository/cache.dart';
import 'package:peerpal/repository/contracts/user_database_contract.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/repository/models/app_user.dart';
import 'package:peerpal/repository/models/user_information.dart';

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

  Stream<AppUser> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? AppUser.empty : _getUserFromFirebaseUser();
    });
  }

  // ToDo: Remove if not used in the future
  Stream<UserInformation> get userInformation {
    return _firestore
        .collection(UserDatabaseContract.users)
        .doc(currentUser.id)
        .snapshots()
        .map((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        var age = snapshot['age'];
        var name = snapshot['name'];
        return UserInformation(age: age, name: name);
      } else {
        return UserInformation.empty;
      }
    });
  }

  AppUser get currentUser {
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

  Future<void> updateUserInformation(UserInformation userInformation) async {
    var userDocument =
        _firestore.collection(UserDatabaseContract.users).doc(currentUser.id);

    cache.set<UserInformation>(
        key: '{$currentUser.uid}-userinformation', value: userInformation);

    await userDocument.set({
      UserInformationField.age.fieldName: userInformation.age,
      UserInformationField.name.fieldName: userInformation.name,
      UserInformationField.phone.fieldName: userInformation.phoneNumber,
      UserInformationField.pictureUrl.fieldName: userInformation.imagePath,
      UserInformationField.discoverFromAge.fieldName:
          userInformation.discoverFromAge,
      UserInformationField.discoverToAge.fieldName:
          userInformation.discoverToAge,
      UserInformationField.discoverCommunicationPreferences.fieldName:
          userInformation.discoverCommunicationPreferences?.map((e) => e.fieldName).toList(),
      UserInformationField.discoverActivities.fieldName:
          userInformation.discoverActivities?.map((e) => e.code).toList(),
    }, SetOptions(merge: true));
  }

  Future<UserInformation> _downloadCurrentUserInformation() async {
    var firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

    var userInformation = UserInformation.empty;
    if (currentUser != null) {
      var userDocumentSnapshot = await _firestore
          .collection(UserDatabaseContract.users)
          .doc(firebaseUser!.uid)
          .get();
      if (userDocumentSnapshot.exists && userDocumentSnapshot.data() != null) {
        var data = userDocumentSnapshot.data();

        var age = data!.containsKey(UserDatabaseContract.userAge)
            ? userDocumentSnapshot.get(UserDatabaseContract.userAge)
            : null;

        var name = data.containsKey(UserDatabaseContract.userName)
            ? userDocumentSnapshot.get(UserDatabaseContract.userName)
            : null;

        var phoneNumber = data.containsKey(UserDatabaseContract.userPhoneNumber)
            ? userDocumentSnapshot.get(UserDatabaseContract.userPhoneNumber)
            : null;

        var imageURL =
            data.containsKey(UserDatabaseContract.userProfilePicturePath)
                ? userDocumentSnapshot
                    .get(UserDatabaseContract.userProfilePicturePath)
                : null;

        var discoverFromAge =
            data.containsKey(UserDatabaseContract.discoverFromAge)
                ? userDocumentSnapshot.get(UserDatabaseContract.discoverFromAge)
                : null;

        var discoverToAge = data.containsKey(UserDatabaseContract.discoverToAge)
            ? userDocumentSnapshot.get(UserDatabaseContract.discoverToAge)
            : null;

        var discoverActivities = data
                .containsKey(UserDatabaseContract.discoverActivities)
            ? List.from(userDocumentSnapshot.get(UserDatabaseContract.discoverActivities))
            : null;

        var discoverCommunicationPreferences = data.containsKey(
                UserDatabaseContract.discoverCommunicationPreferences)
            ? userDocumentSnapshot
                .get(UserDatabaseContract.discoverCommunicationPreferences)
            : null;

        var discoverLocations = data
                .containsKey(UserDatabaseContract.discoverLocations)
            ? userDocumentSnapshot.get(UserDatabaseContract.discoverLocations)
            : null;

        data.containsKey(UserDatabaseContract.userProfilePicturePath)
            ? userDocumentSnapshot
                .get(UserDatabaseContract.userProfilePicturePath)
            : null;

        userInformation = UserInformation(
            age: age,
            name: name,
            phoneNumber: phoneNumber,
            imagePath: imageURL,
            discoverFromAge: discoverFromAge,
            discoverToAge: discoverToAge,
            discoverCommunicationPreferences: discoverCommunicationPreferences?.map((e) => CommunicationType.f).toList(),
            discoverActivities: discoverActivities?.map((e) => Activity(code: e)).toList(),
            discoverLocations: discoverLocations);
      }
    }
    return userInformation;
  }

  Future<UserInformation> getCurrentUserInformation() async {
    var userInformation = UserInformation.empty;
    var cachedUserInformation =
        cache.get<UserInformation>(key: '{$currentUser.uid}-userinformation');
    if (cachedUserInformation != null) {
      userInformation = cachedUserInformation;
    } else {
      userInformation = await _downloadCurrentUserInformation();
      cache.set<UserInformation>(
          key: '{$currentUser.uid}-userinformation', value: userInformation);
    }
    return userInformation;
  }

  AppUser _getUserFromFirebaseUser() {
    var firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

    return (firebaseUser == null
        ? AppUser.empty
        : AppUser(id: firebaseUser.uid, email: firebaseUser.email));
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

  loadCommunicationList() {
    final List<CommunicationType> communicationTypes = [];
    communicationTypes.add(CommunicationType.phone);
    communicationTypes.add(CommunicationType.chat);
    return communicationTypes;
  }
}
