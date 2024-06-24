import 'dart:async';

import 'package:peerpal/discover_feed_v2/domain/peerpal_user.dart';
import 'package:rxdart/rxdart.dart';

abstract class DiscoverRepository {
  Future<BehaviorSubject<List<PeerPALUser>>> discoverPeers(PeerPALUser appUser);
}
