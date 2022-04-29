part of 'friends_overview_cubit.dart';

@immutable
abstract class FriendsOverviewState extends Equatable {
  Stream<List<PeerPALUser>> friends;
  Stream<int> friendRequestsSize;

  FriendsOverviewState(this.friends, this.friendRequestsSize);
}

class FriendsOverviewInitial extends FriendsOverviewState {
  FriendsOverviewInitial() : super(const Stream.empty(), const Stream.empty());

  @override
  List<Object?> get props => [friends, friendRequestsSize];
}

class FriendsOverviewLoading extends FriendsOverviewState {
  FriendsOverviewLoading(friends, friendRequestsSize)
      : super(friends, friendRequestsSize);

  @override
  List<Object?> get props => [friends, friendRequestsSize];
}

class FriendsOverviewLoaded extends FriendsOverviewState {
  FriendsOverviewLoaded(friends, friendRequestsSize)
      : super(friends, friendRequestsSize);

  @override
  List<Object?> get props => [friends, friendRequestsSize];
}
