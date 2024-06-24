import 'package:peerpal/discover_feed_v2/domain/peerpal_user.dart';

abstract class FriendRepository {
  Future<void> sendFriendRequestToUser(PeerPALUser user);

  Future<void> canceledFriendRequest(PeerPALUser userInformation);

  Future<void> friendRequestResponse(
      PeerPALUser userInformation, bool response);

  Stream<List<PeerPALUser>> getFriendList();

  Stream<List<PeerPALUser>> getSentFriendRequestsFromUser();

  Stream<List<PeerPALUser>> getFriendRequestsFromUser();

  Stream<int> getFriendRequestsSize();
}
