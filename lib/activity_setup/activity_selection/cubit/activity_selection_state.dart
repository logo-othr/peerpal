part of 'activity_selection_cubit.dart';

abstract class ActivitySelectionState extends Equatable {
  List<Activity> activities = [];

  ActivitySelectionState(this.activities);
}

class ActivitiesInitial extends ActivitySelectionState {
  ActivitiesInitial() : super([]);

  @override
  List<Object?> get props => [];
}

class ActivitiesLoaded extends ActivitySelectionState {
  ActivitiesLoaded(List<Activity> activities) : super(activities);

  @override
  List<Object?> get props => [activities];
}
