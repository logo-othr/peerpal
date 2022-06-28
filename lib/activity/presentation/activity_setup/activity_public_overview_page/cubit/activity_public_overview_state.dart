part of 'activity_public_overview_cubit.dart';

class ActivityPublicOverviewState extends Equatable {
  final Activity activity;
  final PeerPALUser activityCreator;
  final List<PeerPALUser> attendees;
  final bool isAttendee;

  const ActivityPublicOverviewState(
      this.activity, this.activityCreator, this.attendees, this.isAttendee);

  @override
  List<Object?> get props => [activity, activityCreator, attendees, isAttendee];
}

class ActivityPublicOverviewInitial extends ActivityPublicOverviewState {
  ActivityPublicOverviewInitial()
      : super(Activity.empty, PeerPALUser.empty, [], false);

  @override
  List<Object?> get props => [activity, activityCreator, attendees, isAttendee];
}

class ActivityPublicOverviewLoaded extends ActivityPublicOverviewState {
  final Activity activity;
  final PeerPALUser activityCreator;
  final List<PeerPALUser> attendees;
  final bool isAttendee;

  ActivityPublicOverviewLoaded(
      this.activity, this.activityCreator, this.attendees, this.isAttendee)
      : super(activity, activityCreator, attendees, isAttendee);

  @override
  List<Object?> get props => [activity, activityCreator, attendees, isAttendee];
}
