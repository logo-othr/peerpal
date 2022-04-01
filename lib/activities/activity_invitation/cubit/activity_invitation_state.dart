part of 'activity_invitation_cubit.dart';

@immutable
abstract class ActivityInvitationState extends Equatable {
 final Stream<List<PeerPALUser>> friends;
 final Stream<int> friendRequestsSize; // ToDo: Remove friendRequestSize
 final List<PeerPALUser> invitations;


 ActivityInvitationState(this.friends, this.friendRequestsSize, this.invitations);
}

class ActivityInvitationInitial extends ActivityInvitationState {
 ActivityInvitationInitial() : super(const Stream.empty(), const Stream.empty(), []);

 @override
 List<Object?> get props => [friends, friendRequestsSize, invitations];
}

class ActivityInvitationLoading extends ActivityInvitationState {
 ActivityInvitationLoading(friends, friendRequestsSize)
     : super(friends, friendRequestsSize, []);

 @override
 List<Object?> get props => [friends, friendRequestsSize, invitations];
}

class ActivityInvitationLoaded extends ActivityInvitationState {
 ActivityInvitationLoaded(friends, friendRequestsSize, attendees)
     : super(friends, friendRequestsSize, attendees);

 @override
 List<Object?> get props => [friends, friendRequestsSize, invitations];
}

