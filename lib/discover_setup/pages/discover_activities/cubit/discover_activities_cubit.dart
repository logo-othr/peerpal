import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/domain/repository/activity_repository.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';

part 'discover_activitys_state.dart';

class DiscoverActivitiesCubit extends Cubit<DiscoverActivitiesState> {
  DiscoverActivitiesCubit(this._appUserRepository, this._activityRepository,
      this._getAuthenticatedUser)
      : super(DiscoverActivitiesInitial());
  final AppUserRepository _appUserRepository;
  final ActivityRepository _activityRepository;
  final GetAuthenticatedUser _getAuthenticatedUser;

  @override
  Future<void> loadData() async {
    var activities = await _activityRepository.loadActivityList();
    emit(DiscoverActivitiesSelected(
        activities, <Activity>[].cast<Activity>(), ''));
  }

  @override
  void searchQueryChanged(String searchQuery) {
    if (state is DiscoverActivitiesSelected) {
      emit(DiscoverActivitiesSelected(
          state.activities, state.selectedActivities, searchQuery));
    }
  }

  @override
  void addData(Activity activity) {
    if (state is DiscoverActivitiesSelected) {
      var updatedActivities = List<Activity>.from(state.selectedActivities);
      updatedActivities.add(activity);

      emit(DiscoverActivitiesSelected(
          state.activities, updatedActivities, state.searchQuery));
    }
  }

  @override
  void removeData(Activity activity) {
    if (state is DiscoverActivitiesSelected) {
      var updatedActivities = List<Activity>.from(state.selectedActivities);
      updatedActivities.remove(activity);

      emit(DiscoverActivitiesSelected(
          state.activities, updatedActivities, state.searchQuery));
    }
  }

  @override
  Future<void> postData() async {
    if (state is DiscoverActivitiesSelected) {
      emit(DiscoverActivitiesPosting(
          state.activities, state.selectedActivities));

      var userInformation = await _getAuthenticatedUser();
      var updatedUserInformation = userInformation.copyWith(
          discoverActivities:
              state.selectedActivities.map((e) => e.code!).toList());
      await _appUserRepository.updateUser(updatedUserInformation);

      emit(
          DiscoverActivitiesPosted(state.activities, state.selectedActivities));
    }
  }

  void toggleData(Activity activity) {
    if (state.selectedActivities.contains(activity)) {
      removeData(activity);
    } else {
      addData(activity);
    }
  }
}
