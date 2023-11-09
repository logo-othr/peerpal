import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:rxdart/subjects.dart';

class FindPeers {
  //final ChatRepository chatRepository;
  final AppUserRepository userRepository;
  final AuthenticationRepository authenticationRepository;

  FindPeers(
      { //required this.chatRepository,
      required this.userRepository,
      required this.authenticationRepository});

  Future<BehaviorSubject<List<PeerPALUser>>> call() async {
    return await userRepository
        .discoverPeers(authenticationRepository.currentUser.id);
  }
}
