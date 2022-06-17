import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/get_user_usecase.dart';
import 'package:peerpal/repository/models/location.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

part 'discover_location_state.dart';

class DiscoverLocationCubit extends Cubit<DiscoverLocationState> {
  DiscoverLocationCubit(this._appUserRepository, this._getAuthenticatedUser)
      : super(DiscoverLocationInitial());

  final AppUserRepository _appUserRepository;
  final GetAuthenticatedUser _getAuthenticatedUser;

  Future<void> loadData() async {
    var locations = await _appUserRepository.loadLocations();
    PeerPALUser authenticatedUser = await _getAuthenticatedUser();
    List<Location> selectedLocations =
        authenticatedUser.discoverLocations ?? <Location>[].cast<Location>();
    emit(DiscoverLocationLoaded(
        locations, selectedLocations, <Location>[].cast<Location>()));
  }

  void searchQueryChanged(String searchQuery) {
    if (state is DiscoverLocationLoaded) {
      var filteredLocations =
          _searchForLocationsStartingWith(searchQuery, state.locations);
      for (var location in state.selectedLocations) {
        filteredLocations.remove(location);
      }
      emit(DiscoverLocationLoaded(
          state.locations, state.selectedLocations, filteredLocations));
    }
  }

  List<Location> _searchForLocationsStartingWith(
      String searchQuery, List<Location> locationsFromJSON) {
    var locations = <Location>[];
    var allLocations = List<Location>.from((locationsFromJSON));

    if (searchQuery.trim() != "") {
      searchQuery = searchQuery.toLowerCase();

      locations.addAll(_filterSearchResults(searchQuery, allLocations));
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
    if (state is DiscoverLocationLoaded) {
      var updatedLocations = List<Location>.from(state.selectedLocations);
      updatedLocations.add(location);

      state.filteredLocations.remove(location);
      emit(DiscoverLocationLoaded(
          state.locations, updatedLocations, state.filteredLocations));
    }
  }

  void removeLocation(Location location) {
    if (state is DiscoverLocationLoaded) {
      var updatedLocations = List<Location>.from(state.selectedLocations);
      updatedLocations.remove(location);
      emit(DiscoverLocationLoaded(
          state.locations, updatedLocations, state.filteredLocations));
    }
  }

  Future<void> postLocations() async {
    if (state is DiscoverLocationLoaded) {
      emit(DiscoverLocationPosting(state.locations, state.selectedLocations));

      var userInformation = await _getAuthenticatedUser();
      var updatedUserInformation =
          userInformation.copyWith(discoverLocations: state.selectedLocations);
      await _appUserRepository.updateUserInformation(updatedUserInformation);

      emit(DiscoverLocationPosted(state.locations, state.selectedLocations));
    }
  }
}
