part of 'activity_overview_cubit.dart';

class ActivityOverviewState extends Equatable {
  final Activity activity;
  final PeerPALUser activityCreator;
  final List<PeerPALUser> attendees;
  final List<PeerPALUser> invitationIds;

  const ActivityOverviewState(
      this.activity, this.activityCreator, this.attendees, this.invitationIds);

  @override
  List<Object?> get props =>
      [activity, activityCreator, attendees, invitationIds];
}

class ActivityOverviewInitial extends ActivityOverviewState {
  ActivityOverviewInitial() : super(Activity.empty, PeerPALUser.empty, [], []);

  @override
  List<Object?> get props =>
      [activity, activityCreator, attendees, invitationIds];
}

class ActivityOverviewLoaded extends ActivityOverviewState {
  final Activity activity;
  final PeerPALUser activityCreator;
  final List<PeerPALUser> attendees;
  final List<PeerPALUser> invitationIds;

  ActivityOverviewLoaded(
      this.activity, this.activityCreator, this.attendees, this.invitationIds)
      : super(activity, activityCreator, attendees, invitationIds);

  @override
  List<Object?> get props =>
      [activity, activityCreator, attendees, invitationIds];
}
