part of 'friend_requests_cubit.dart';

@immutable
abstract class FriendRequestsState extends Equatable {
  Stream<List<dynamic>> friendRequests;

  FriendRequestsState(this.friendRequests);
}

class FriendRequestsInitial extends FriendRequestsState {
  FriendRequestsInitial() : super(const Stream.empty());

  @override
  List<Object?> get props => [friendRequests];
}

class FriendRequestsLoading extends FriendRequestsState {
  FriendRequestsLoading(friendRequests) : super(friendRequests);

  @override
  List<Object?> get props => [friendRequests];
}

class FriendRequestsLoaded extends FriendRequestsState {
  FriendRequestsLoaded(friendRequests) : super(friendRequests);

  @override
  List<Object?> get props => [friendRequests];
}

class FriendRequestsError extends FriendRequestsState {
  final String message;

  FriendRequestsError(this.message) : super(const Stream.empty());

  @override
  List<Object?> get props => [message];
}
