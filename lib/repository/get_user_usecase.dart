import 'package:peerpal/login_flow/persistence/authentication_repository.dart';
import 'package:peerpal/peerpal_user/domain/peerpal_user.dart';
import 'package:peerpal/repository/app_user_repository.dart';

class GetAuthenticatedUser {
  final AppUserRepository userRepository;
  final AuthenticationRepository authRepository;

  GetAuthenticatedUser(this.userRepository, this.authRepository);

  Future<PeerPALUser> call() async {
    String currentUserId = authRepository.currentUser.id;
    PeerPALUser currentUser =
        await userRepository.getCurrentUserInformation(currentUserId);
    return currentUser;
  }
}
