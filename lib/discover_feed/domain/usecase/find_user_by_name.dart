import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

class FindUserByName {
  final AppUserRepository userRepository;

  FindUserByName({
    required this.userRepository,
  });

  Future<List<PeerPALUser>> call(String username) async {
    return await userRepository.findUserByName(username);
  }

  String _sanitizeUsername(String userName) {
    return userName.toString().trim();
  }
}
