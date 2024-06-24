import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/friends/domain/repository/friend_repository.dart';

class SendFriendRequest {
  final FriendRepository friendRepository;
  final AppUserRepository appUserRepository;

  SendFriendRequest(this.friendRepository, this.appUserRepository);

  Future<void> call(String userId) async {
    PeerPALUser partner = await appUserRepository.getUser(userId);
    return await friendRepository.sendFriendRequestToUser(partner);
  }
}
