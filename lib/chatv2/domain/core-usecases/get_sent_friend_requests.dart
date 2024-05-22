import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/friends/domain/repository/friend_repository.dart';

class GetSentFriendRequests {
  final FriendRepository friendRepository;

  GetSentFriendRequests(this.friendRepository);

  Stream<List<PeerPALUser>> call() {
    return friendRepository.getSentFriendRequestsFromUser();
  }
}
