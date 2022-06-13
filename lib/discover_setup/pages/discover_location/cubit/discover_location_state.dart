part of 'discover_location_cubit.dart';

abstract class DiscoverLocationState extends Equatable {
  List<Location> locations;
  List<Location> selectedLocations;
  List<Location> filteredLocations;

  DiscoverLocationState(
      this.locations, this.selectedLocations, this.filteredLocations);
}

class DiscoverLocationInitial extends DiscoverLocationState {
  DiscoverLocationInitial() : super([], [], []);

  @override
  List<Object?> get props => [locations, selectedLocations, filteredLocations];
}

class DiscoverLocationLoaded extends DiscoverLocationState {
  DiscoverLocationLoaded(List<Location> locations,
      List<Location> selectedLocations, List<Location> filteredLocations)
      : super(locations, selectedLocations, filteredLocations);

  @override
  List<Object?> get props => [locations, selectedLocations, filteredLocations];
}

class DiscoverLocationPosting extends DiscoverLocationState {
  DiscoverLocationPosting(
      List<Location> locations, List<Location> selectedLocations)
      : super(locations, selectedLocations, []);

  @override
  List<Object?> get props => [locations, selectedLocations, filteredLocations];
}

class DiscoverLocationPosted extends DiscoverLocationState {
  DiscoverLocationPosted(
      List<Location> locations, List<Location> selectedLocations)
      : super(locations, selectedLocations, []);

  @override
  List<Object?> get props => [locations, selectedLocations, filteredLocations];
}

class DiscoverLocationError extends DiscoverLocationState {
  final String message;

  DiscoverLocationError(this.message) : super([], [], []);

  @override
  List<Object?> get props => [message];
}
