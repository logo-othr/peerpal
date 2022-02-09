part of 'activity_overview_cubit.dart';

 class ActivityOverviewState extends Equatable {

  final Activity activity;
  final PeerPALUser activityCreator;
  final List<PeerPALUser> attendees;

  const ActivityOverviewState(this.activity, this.activityCreator, this.attendees);
  @override
  List<Object?> get props => [activity, activityCreator, attendees];
}

class ActivityOverviewInitial extends ActivityOverviewState {
 ActivityOverviewInitial() : super(Activity.empty, PeerPALUser.empty, []);

 @override
 List<Object?> get props => [activity, activityCreator, attendees];
}

class ActivityOverviewLoaded extends ActivityOverviewState {
 final Activity activity;
 final PeerPALUser activityCreator;
 final List<PeerPALUser> attendees;

 ActivityOverviewLoaded(this.activity, this.activityCreator, this.attendees) : super(activity, activityCreator, attendees);

 @override
 List<Object?> get props => [activity, activityCreator, attendees];

}
