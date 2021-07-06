import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:peerpal/repository/models/app_user.dart';

class SignUpFailure implements Exception {
  final String message;
  SignUpFailure({this.message = "Fehler bei der Registierung"});
}

class LoginFailure implements Exception {
  final String message;
  LoginFailure({this.message = "Fehler beim Login."});
}

class LogoutFailure implements Exception {
  final String message;
  LogoutFailure({this.message = "Fehler beim Ausloggen."});
}

class AuthenticationRepository {

  final firebase_auth.FirebaseAuth _firebaseAuth;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthenticationRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  Stream<AppUser> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? AppUser.empty : _getUserFromFirebaseUser();
    });
  }

  AppUser get currentUser {
    return _firebaseAuth.currentUser == null ? AppUser.empty : _getUserFromFirebaseUser();
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    }  on FirebaseAuthException catch  (e) {
      //print('Failed with error code: ${e.code}');
      //print(e.message);
      // https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html
      switch(e.code) {
        case "email-already-in-use":
          throw SignUpFailure(message: "Diese E-Mail ist bereits in Benutzung.");
        case "operation-not-allowed":
          throw SignUpFailure(message: "Es ist ein Fehler aufgetreten. Registierungen sind deaktiviert.");
        case "weak-password:":
          throw SignUpFailure(message: "Das gewählte Passwort ist zu schwach.");
        case "too-many-requests":
          throw SignUpFailure(message: "Der Server ist ausgelastet. Bitte versuche es später oder morgen noch einmal.");
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
    }  on FirebaseAuthException catch  (e) {
      //print('Failed with error code: ${e.code}');
      //print(e.message);
      // https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithEmailAndPassword.html
      switch(e.code) {
        case "wrong-password":
        case "user-not-found":
          throw LoginFailure(message: "Falsches Passwort oder die der Nutzer existiert nicht.");
        case "user-disabled":
          throw LoginFailure(message: "Der Account wurde deaktiviert.");
        case "invalid-email":
          throw LoginFailure(message: "Die E-Mail ist ungültig.");
        case "too-many-requests":
          throw LoginFailure(message: "Der Server ist ausgelastet. Bitte versuche es später oder morgen noch einmal.");
        default:
          throw LoginFailure();
      }
    } on Exception {
      throw LoginFailure();
    }
  }


  Future<void> logout() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } on Exception {
      throw LogoutFailure();
    }
  }

  Future<void> updateAge(int selectedAge) async {
    return _firestore.collection('users').doc(currentUser.id).set({
      'age': selectedAge,
    }, SetOptions(merge: true));
  }

  Future<void> updateName(int selectedAge) async {
    return _firestore.collection('users').doc(currentUser.id).set({
      'age': selectedAge,
    }, SetOptions(merge: true));
  }

  _getUserFromFirebaseUser() {
    firebase_auth.User? firebaseUser =
        firebase_auth.FirebaseAuth.instance.currentUser;
    return (firebaseUser == null
        ? null
        : AppUser(id: firebaseUser.uid, email: firebaseUser.email));
  }
}



