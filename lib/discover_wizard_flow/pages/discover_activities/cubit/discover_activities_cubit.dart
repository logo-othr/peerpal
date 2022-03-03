import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/repository/activity_repository.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/activity.dart';

part 'discover_activitys_state.dart';

class DiscoverActivitiesCubit
    extends Cubit<DiscoverActivitiesState> {
  DiscoverActivitiesCubit(this._appUserRepository, this._activityRepository)
      : super(DiscoverActivitiesInitial());
  final AppUserRepository _appUserRepository;
  final ActivityRepository _activityRepository;

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

      var userInformation = await _appUserRepository.getCurrentUserInformation();
      var updatedUserInformation = userInformation.copyWith(
          discoverActivities: state.selectedActivities.map((e) => e.code!).toList());
      await _appUserRepository.updateUserInformation(updatedUserInformation);

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
