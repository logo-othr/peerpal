import 'package:peerpal/app/domain/core/cache.dart';
import 'package:peerpal/authentication/domain/auth_service.dart';
import 'package:peerpal/authentication/domain/models/auth_user.dart';

class AuthenticationRepository {
  final AuthService _authService;
  final Cache cache;

  AuthenticationRepository(
      {required AuthService authService, required this.cache})
      : _authService = authService;

  Stream<AuthUser> get user => _authService.user;

  AuthUser get currentUser => _authService.currentUser;

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _authService.signUp(email: email, password: password);
    } catch (e) {
      throw e;
    }
  }

  Future<void> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _authService.loginWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> resetPassword({required String email}) async {
    try {
      return await _authService.resetPassword(email: email);
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      // TODO: Check if the cache is used somewhere?
      //  cache.clearCache(key: '${currentUser.id}-userinformation');
    } catch (e) {
      throw e;
    }
  }
}
