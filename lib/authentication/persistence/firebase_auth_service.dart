import 'package:firebase_auth/firebase_auth.dart';
import 'package:peerpal/authentication/domain/auth_service.dart';

class AuthServiceFirebase implements AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthServiceFirebase({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  Future<String> getCurrentUserId() async {
    return _firebaseAuth.currentUser!.uid;
  }
}
