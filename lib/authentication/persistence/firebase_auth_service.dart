import 'package:firebase_auth/firebase_auth.dart';
import 'package:peerpal/app_logger.dart';
import 'package:peerpal/authentication/domain/auth_service.dart';
import 'package:peerpal/authentication/domain/models/auth_user.dart';
import 'package:peerpal/authentication/exceptions/login_exception.dart';
import 'package:peerpal/authentication/exceptions/logout_exception.dart';
import 'package:peerpal/authentication/exceptions/sign_up_failure.dart';
import 'package:peerpal/authentication/strings/auth_error_codes.dart';
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
      if (e.code == AuthErrorCodes.userNotFound) {
        logger.i(AuthErrorMessages.noUserFound);
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
      switch (e.code) {
        case AuthErrorCodes.emailAlreadyInUse:
          throw SignUpFailure(message: AuthErrorMessages.emailAlreadyInUse);
        case AuthErrorCodes.operationNotAllowed:
          throw SignUpFailure(message: AuthErrorMessages.operationNotAllowed);
        case AuthErrorCodes.weakPassword:
          throw SignUpFailure(message: AuthErrorMessages.weakPassword);
        case AuthErrorCodes.tooManyRequests:
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
      switch (e.code) {
        case AuthErrorCodes.wrongPassword:
        case AuthErrorCodes.userNotFound:
          throw LoginException(
              message: AuthErrorMessages.wrongPasswordOrUserNotFound);
        case AuthErrorCodes.userDisabled:
          throw LoginException(message: AuthErrorMessages.userDisabled);
        case AuthErrorCodes.invalidEmail:
          throw LoginException(message: AuthErrorMessages.invalidEmail);
        case AuthErrorCodes.tooManyRequests:
          throw LoginException(message: AuthErrorMessages.tooManyRequests);
        default:
          throw LoginException();
      }
    } on Exception {
      throw LoginException();
    }
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
