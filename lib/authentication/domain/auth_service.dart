import 'package:peerpal/authentication/domain/models/auth_user.dart';

abstract class AuthService {
  Future<String> getCurrentUserId();

  Stream<AuthUser> get user;

  Future<void> signUp({required String email, required String password});

  Future<void> loginWithEmailAndPassword(
      {required String email, required String password});

  Future<void> logout();

  Future<bool> resetPassword({required String email});

  AuthUser get currentUser;
}
