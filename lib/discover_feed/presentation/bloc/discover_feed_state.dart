part of 'discover_feed_bloc.dart';

enum DiscoverTabStatus { initial, success, error }

class DiscoverTabState extends Equatable {
  const DiscoverTabState({
    this.status = DiscoverTabStatus.initial,
    this.userStream = const Stream.empty(),
    this.searchResults = const [],
  });

  final DiscoverTabStatus status;
  final Stream<List<PeerPALUser>> userStream;
  final List<PeerPALUser> searchResults;

  DiscoverTabState copyWith({
    DiscoverTabStatus? status,
    Stream<List<PeerPALUser>>? userStream,
    List<PeerPALUser>? searchResults,
  }) {
    return DiscoverTabState(
        status: status ?? this.status,
        userStream: userStream ?? this.userStream,
        searchResults: searchResults ?? this.searchResults);
  }

  @override
  List<Object> get props => [status, userStream, searchResults];
}
