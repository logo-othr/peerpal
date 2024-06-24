import 'package:peerpal/discover_feed_v2/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed_v2/domain/peerpal_user.dart';

class GetUser {
  final AppUserRepository userRepository;

  GetUser(this.userRepository);

  Future<PeerPALUser> call(String userId) async {
    return await userRepository.getUser(userId);
  }
}
