part of 'discover_activities_cubit.dart';

abstract class DiscoverActivitiesState extends Equatable {
  List<Activity> activities;
  List<Activity> selectedActivities;
  String searchQuery;

  DiscoverActivitiesState(
      this.activities, this.selectedActivities, this.searchQuery);
}

class DiscoverActivitiesInitial extends DiscoverActivitiesState {
  DiscoverActivitiesInitial() : super([], [], '');

  @override
  List<Object?> get props => [activities, selectedActivities];
}

class DiscoverActivitiesLoaded extends DiscoverActivitiesState {
  DiscoverActivitiesLoaded(List<Activity> activities)
      : super(activities, [], '');

  @override
  List<Object?> get props => [activities, selectedActivities, searchQuery];
}

class DiscoverActivitiesSelected extends DiscoverActivitiesState {
  DiscoverActivitiesSelected(List<Activity> activities,
      List<Activity> selectedActivities, String searchQuery)
      : super(activities, selectedActivities, searchQuery);

  @override
  List<Object?> get props => [activities, selectedActivities, searchQuery];
}

class DiscoverActivitiesPosting extends DiscoverActivitiesState {
  DiscoverActivitiesPosting(
      List<Activity> activities, List<Activity> selectedActivities)
      : super(activities, selectedActivities, '');

  @override
  List<Object?> get props => [activities, selectedActivities, searchQuery];
}

class DiscoverActivitiesPosted extends DiscoverActivitiesState {
  DiscoverActivitiesPosted(
      List<Activity> activities, List<Activity> selectedActivities)
      : super(activities, selectedActivities, '');

  @override
  List<Object?> get props => [activities, selectedActivities, searchQuery];
}

class DiscoverActivitiesError extends DiscoverActivitiesState {
  final String message;

  DiscoverActivitiesError(this.message) : super([], [], '');

  @override
  List<Object?> get props => [message];
}
