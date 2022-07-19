import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/activity/data/repository/activity_repository.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/data/location.dart';

part 'activity_location_state.dart';

class ActivityLocationCubit extends Cubit<ActivityLocationInputState> {
  ActivityLocationCubit(this._activityRepository)
      : super(ActivityLocationInitial());

  final ActivityRepository _activityRepository;

  Future<void> loadData() async {
    var locations = await _activityRepository.loadLocations();
    var activity = await _activityRepository.getCurrentActivity();
    var locationList = activity.location != null
        ? <Location>[activity.location!]
        : <Location>[].cast<Location>();
    emit(ActivityLocationLoaded(
        locations, locationList, <Location>[].cast<Location>()));
  }

  void searchQueryChanged(String searchQuery) {
    if (state is ActivityLocationLoaded) {
      var filteredLocations =
          _searchForLocationsStartingWith(searchQuery, state.locations);
      for (var location in state.selectedLocations) {
        filteredLocations.remove(location);
      }
      emit(ActivityLocationLoaded(
          state.locations, state.selectedLocations, filteredLocations));
    }
  }

  List<Location> _searchForLocationsStartingWith(
      String searchQuery, List<Location> locationsFromJSON) {
    var locations = <Location>[];
    var allActivityLocations = List<Location>.from((locationsFromJSON));

    if (searchQuery.trim() != "") {
      searchQuery = searchQuery.toLowerCase();

      locations.addAll(_filterSearchResults(searchQuery, allActivityLocations));
    }
    return locations;
  }

  List<Location> _filterSearchResults(
      String searchQuery, List<Location> locations) {
    List<Location> locationData = [];
    locations.forEach((location) {
      if (location.place.toString().toLowerCase().startsWith(searchQuery) ||
          location.zipcode.toString().toLowerCase().startsWith(searchQuery)) {
        if (!locationData.contains(location)) locationData.add(location);
      }
    });
    return locationData;
  }

  void addLocation(Location location) {
    if (state is ActivityLocationLoaded) {
      var updatedActivityLocations =
          List<Location>.from(state.selectedLocations);
      updatedActivityLocations.add(location);

      state.filteredLocations.remove(location);
      emit(ActivityLocationLoaded(
          state.locations, updatedActivityLocations, state.filteredLocations));
    }
  }

  void removeLocation(Location location) {
    if (state is ActivityLocationLoaded) {
      var updatedActivityLocations =
          List<Location>.from(state.selectedLocations);
      updatedActivityLocations.remove(location);
      emit(ActivityLocationLoaded(
          state.locations, updatedActivityLocations, state.filteredLocations));
    }
  }

  void updateSelectedLocation(Location location) {
    if (state is ActivityLocationLoaded) {
      state.selectedLocations.clear();
      var updatedActivityLocations =
          List<Location>.from(state.selectedLocations);
      updatedActivityLocations.add(location);

      state.filteredLocations.remove(location); // ToDo: Test!
      emit(ActivityLocationLoaded(
          state.locations, updatedActivityLocations, state.filteredLocations));
    }
  }

  Future<Activity> postActivityLocations() async {
    emit(ActivityLocationPosting(state.locations, state.selectedLocations));

    var currentActivity = await _activityRepository.getCurrentActivity();
    var activity =
        currentActivity.copyWith(location: state.selectedLocations[0]);
    _activityRepository.updateLocalActivity(activity);

    emit(ActivityLocationPosted(state.locations, state.selectedLocations));
    return activity;
  }
}
