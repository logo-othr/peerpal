part of 'discover_feed_cubit.dart';

@immutable
abstract class DiscoverFeedState implements Equatable {
  final Stream<List<PeerPALUser>> userStream;
  final List<PeerPALUser> searchResults;

  DiscoverFeedState({required this.userStream, required this.searchResults});

  @override
  List<Object?> get props => [userStream, searchResults];

  @override
  bool? get stringify => true;
}

class DiscoverFeedInitial extends DiscoverFeedState {
  DiscoverFeedInitial() : super(userStream: Stream.empty(), searchResults: []);

  @override
  List<Object?> get props => [userStream, searchResults];

  @override
  bool? get stringify => true;
}

class DiscoverFeedLoaded extends DiscoverFeedState {
  final Stream<List<PeerPALUser>> userStream;
  final List<PeerPALUser> searchResults;

  DiscoverFeedLoaded({required this.userStream, required this.searchResults})
      : super(userStream: userStream, searchResults: searchResults);

  @override
  List<Object?> get props => [userStream, searchResults];

  @override
  bool? get stringify => true;
}
