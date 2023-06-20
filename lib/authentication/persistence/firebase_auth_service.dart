import 'package:firebase_auth/firebase_auth.dart';
import 'package:peerpal/app_logger.dart';
import 'package:peerpal/authentication/domain/auth_service.dart';
import 'package:peerpal/authentication/domain/models/auth_user.dart';
import 'package:peerpal/authentication/exceptions/login_exception.dart';
import 'package:peerpal/authentication/exceptions/logout_exception.dart';
import 'package:peerpal/authentication/exceptions/sign_up_failure.dart';
import 'package:peerpal/authentication/strings/auth_error_messages.dart';

class AuthServiceFirebase implements AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthServiceFirebase({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  Future<String> getCurrentUserId() async {
    return _firebaseAuth.currentUser!.uid;
  }

  @override
  Stream<AuthUser> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? AuthUser.empty : _getUserFromFirebaseUser();
    });
  }

  AuthUser _getUserFromFirebaseUser() {
    var firebaseUser = _firebaseAuth.currentUser;

    return (firebaseUser == null
        ? AuthUser.empty
        : AuthUser(id: firebaseUser.uid, email: firebaseUser.email));
  }

  AuthUser get currentUser {
    return _getUserFromFirebaseUser();
  }

  @override
  Future<bool> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      logger.i(AuthErrorMessages.passwordResetEmailSent);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        logger.i(AuthErrorMessages.noUserFound);
        // ToDo: throw exception
        return false;
      }
    }
    return false;
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
          throw SignUpFailure(message: AuthErrorMessages.emailAlreadyInUse);
        case 'operation-not-allowed':
          throw SignUpFailure(message: AuthErrorMessages.operationNotAllowed);
        case 'weak-password:':
          throw SignUpFailure(message: AuthErrorMessages.weakPassword);
        case 'too-many-requests':
          throw SignUpFailure(message: AuthErrorMessages.tooManyRequests);
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
              message: AuthErrorMessages.wrongPasswordOrUserNotFound);
        case 'user-disabled':
          throw LoginException(message: AuthErrorMessages.userDisabled);
        case 'invalid-email':
          throw LoginException(message: AuthErrorMessages.invalidEmail);
        case 'too-many-requests':
          throw LoginException(message: AuthErrorMessages.tooManyRequests);
        default:
          throw LoginException();
      }
    } on Exception {
      throw LoginException();
    }

    // await registerFCMDeviceToken(); // disabled because we want to register the device token only after the profile and discover setup ToDo: Test.
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } on Exception {
      throw LogoutException();
    }
  }
}
