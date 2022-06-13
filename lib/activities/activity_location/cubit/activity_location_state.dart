part of 'activity_location_cubit.dart';

abstract class ActivityLocationInputState extends Equatable {
  List<Location> locations;
  List<Location> selectedLocations;
  List<Location> filteredLocations;

  ActivityLocationInputState(
      this.locations, this.selectedLocations, this.filteredLocations);
}

class ActivityLocationInitial extends ActivityLocationInputState {
  ActivityLocationInitial() : super([], [], []);

  @override
  List<Object?> get props => [locations, selectedLocations, filteredLocations];
}

class ActivityLocationLoaded extends ActivityLocationInputState {
  ActivityLocationLoaded(List<Location> locations,
      List<Location> selectedLocations, List<Location> filteredLocations)
      : super(locations, selectedLocations, filteredLocations);

  @override
  List<Object?> get props => [locations, selectedLocations, filteredLocations];
}

class ActivityLocationPosting extends ActivityLocationInputState {
  ActivityLocationPosting(
      List<Location> locations, List<Location> selectedLocations)
      : super(locations, selectedLocations, []);

  @override
  List<Object?> get props => [locations, selectedLocations, filteredLocations];
}

class ActivityLocationPosted extends ActivityLocationInputState {
  ActivityLocationPosted(
      List<Location> locations, List<Location> selectedLocations)
      : super(locations, selectedLocations, []);

  @override
  List<Object?> get props => [locations, selectedLocations, filteredLocations];
}
