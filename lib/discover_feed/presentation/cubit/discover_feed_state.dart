part of 'discover_feed_cubit.dart';

@immutable
abstract class DiscoverFeedState implements Equatable {
  final Stream<List<PeerPALUser>> userStream;
  final List<PeerPALUser> searchResults;
  final bool isSearchEmpty = true;
  final bool isSearchFocused = false;

  DiscoverFeedState(
      {required this.userStream,
      required this.searchResults,
      required isSearchEmpty,
      required isSearchFocused});

  @override
  List<Object?> get props =>
      [userStream, searchResults, isSearchEmpty, isSearchFocused];

  @override
  bool? get stringify => true;
}

class DiscoverFeedInitial extends DiscoverFeedState {
  DiscoverFeedInitial()
      : super(
            userStream: Stream.empty(),
            searchResults: [],
            isSearchEmpty: true,
            isSearchFocused: false);

  @override
  List<Object?> get props =>
      [userStream, searchResults, isSearchEmpty, isSearchFocused];

  @override
  bool? get stringify => true;
}

class DiscoverFeedLoaded extends DiscoverFeedState {
  final Stream<List<PeerPALUser>> userStream;
  final List<PeerPALUser> searchResults;
  final bool isSearchEmpty;
  final bool isSearchFocused;
  final bool searchActive;

  DiscoverFeedLoaded(
      {required this.userStream,
      required this.searchResults,
      required this.isSearchEmpty,
      required this.isSearchFocused,
      required this.searchActive})
      : super(
            userStream: Stream.empty(),
            searchResults: [],
            isSearchEmpty: true,
            isSearchFocused: false);

  @override
  List<Object?> get props =>
      [userStream, searchResults, isSearchEmpty, isSearchFocused, searchActive];

  @override
  bool? get stringify => true;
}
