import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/activity.dart';

part 'discover_activitys_state.dart';

class DiscoverActivitiesCubit extends Cubit<DiscoverActivitiesState> {
  DiscoverActivitiesCubit(this._appUserRepository)
      : super(DiscoverActivitiesInitial());

  final AppUserRepository _appUserRepository;

  Future<void> loadActivities() async {
    var activities = await _appUserRepository.loadActivityList();
    emit(DiscoverActivitiesSelected(activities, [].cast<Activity>(), ''));
  }

  void searchQueryChanged(String searchQuery) {
    if (state is DiscoverActivitiesSelected) {
      emit(DiscoverActivitiesSelected(
          state.activities, state.selectedActivities, searchQuery));
    }
  }

  void addActivity(Activity activity) {
    if (state is DiscoverActivitiesSelected) {
      var updatedActivities = List<Activity>.from(state.selectedActivities);
      updatedActivities.add(activity);

      emit(DiscoverActivitiesSelected(state.activities,
          updatedActivities, state.searchQuery));
    }
  }

  void removeActivity(Activity activity) {
    if (state is DiscoverActivitiesSelected) {
      var updatedActivities = List<Activity>.from(state.selectedActivities);
      updatedActivities.remove(activity);

      emit(DiscoverActivitiesSelected(state.activities,
          updatedActivities, state.searchQuery));
    }
  }

  Future<void> postActivities(
      List<Activity> activities, List<Activity> selectedActivities) async {
    emit(DiscoverActivitiesPosting(activities, selectedActivities));

    var userInformation = await _appUserRepository.getCurrentUserInformation();
    var updatedUserInformation =
        userInformation.copyWith(discoverActivities: selectedActivities);
    await _appUserRepository.updateUserInformation(updatedUserInformation);

    emit(DiscoverActivitiesPosted(activities, selectedActivities));
  }
}
