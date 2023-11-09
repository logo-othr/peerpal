import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_feed/domain/repository/discover_repository.dart';
import 'package:rxdart/subjects.dart';

class FindPeers {
  //final ChatRepository chatRepository;
  final AppUserRepository userRepository;
  final AuthenticationRepository authenticationRepository;
  final DiscoverRepository discoverRepository;

  FindPeers(
      { //required this.chatRepository,
      required this.userRepository,
      required this.authenticationRepository,
      required this.discoverRepository});

  Future<BehaviorSubject<List<PeerPALUser>>> call() async {
    var appUser = await userRepository.getAppUser();
    return await discoverRepository.discoverPeers(appUser);
  }
}
