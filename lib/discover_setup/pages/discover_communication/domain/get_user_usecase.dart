import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

class GetAuthenticatedUser {
  final AppUserRepository userRepository;
  final AuthenticationRepository authRepository;

  GetAuthenticatedUser(this.userRepository, this.authRepository);

  Future<PeerPALUser> call() async {
    String currentUserId = authRepository.currentUser.id;
    PeerPALUser currentUser =
        await userRepository.getCurrentUserInformation(currentUserId);
    if (currentUser.id == null)
      currentUser = currentUser.copyWith(id: currentUserId);
    return currentUser;
  }
}
