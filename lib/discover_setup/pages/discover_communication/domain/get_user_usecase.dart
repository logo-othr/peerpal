import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/discover_feed_v2/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed_v2/domain/peerpal_user.dart';

class GetAuthenticatedUser {
  final AppUserRepository userRepository;
  final AuthenticationRepository authRepository;

  GetAuthenticatedUser(this.userRepository, this.authRepository);

  Future<PeerPALUser> call() async {
    String currentUserId = authRepository.currentUser.id;
    PeerPALUser currentUser = await userRepository.getAppUser();
    // When the user in the database doesn't exist, return a empty user object with the firebase auth id
    if (currentUser.id == null)
      currentUser = currentUser.copyWith(id: currentUserId);
    return currentUser;
  }
}
