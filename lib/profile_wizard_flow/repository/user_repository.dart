import 'package:peerpal/profile_wizard_flow/models/User.dart';
import 'package:peerpal/profile_wizard_flow/models/profile.dart';

abstract class AppUserRepository {
  /// Throws [NetworkException].
  Future<Profile> fetchUserProfile();

  postAge(int selectedAge) {}
}

class FakeUserRepository implements AppUserRepository {
  Future<Profile> fetchUserProfile() async {
    return Future.delayed(
      Duration(seconds: 1),
      () {
        return Profile(age: 5);
      },
    );
  }

  @override
  Future<int> postAge(int selectedAge) {
    return Future.delayed(
      Duration(seconds: 1),
      () async {
        // simulate post (1 second) and fetch the updated value
        Profile userProfile = await fetchUserProfile();
        return userProfile.age ?? 0;
      },
    );
  }
}

class NetworkException implements Exception {}
